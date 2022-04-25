import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:technonhiptim/helper/media_query_helper.dart';
import 'package:technonhiptim/helper/models.dart';
import 'package:technonhiptim/helper/mqttClientWrapper.dart';
import 'package:technonhiptim/helper/shared_prefs_helper.dart';
import 'package:technonhiptim/main/department_list_screen.dart';
import 'package:technonhiptim/model/department.dart';
import 'package:technonhiptim/model/thietbi.dart';
import 'package:technonhiptim/navigator.dart';
import 'package:technonhiptim/response/device_response.dart';

import '../helper/constants.dart' as Constants;

class DeviceDetailScreen extends StatefulWidget {
  final ThietBi thietBi;
  final Function(dynamic) updateCallback;

  const DeviceDetailScreen({
    Key key,
    this.thietBi,
    this.updateCallback,
  }) : super(key: key);

  @override
  _DeviceDetailScreenState createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  static const DELETE_TB = 'deletetb';

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List<Department> departments = List();
  MQTTClientWrapper mqttClientWrapper;

  String pubTopic;
  bool isLoading = true;
  String iduser = "";
  SharedPrefsHelper sharedPrefsHelper;

  @override
  void initState() {
    isLoading = false;
    initMqtt();
    getSharedPref();

    super.initState();
  }

  Future<void> getSharedPref() async {
    sharedPrefsHelper = SharedPrefsHelper();
    iduser = await sharedPrefsHelper.getStringValuesSF('iduser');
  }

  Future<void> initMqtt() async {
    mqttClientWrapper = MQTTClientWrapper(
        () => print('Success'), (message) => handleDepartment(message));
    await mqttClientWrapper.prepareMqttClient(Constants.mac);

    mqttClientWrapper.subscribe(widget.thietBi.mathietbi, (_message) {
      print('_DetailScreenState.initMqtt $_message');
      var result = _message.replaceAll("\"", "").split('&');
      String trangthai = '';

      if (result[1] != null) {
        switch (result[1]) {
          case '1':
            trangthai = 'Lọc';
            break;
          case '2':
            trangthai = 'Xả';
            break;
          case '3':
            trangthai = 'Rửa hóa chất';
            break;
          case '4':
            trangthai = 'Dừng máy';
            break;
          case '5':
            trangthai = 'Mất kết nối';
            break;
        }
        widget.thietBi.trangthai = trangthai;
        widget.thietBi.TDS = result[0];
        setState(() {});
      }
    });
  }

  Future<void> publishMessage(String topic, String message) async {
    if (mqttClientWrapper.connectionState ==
        MqttCurrentConnectionState.CONNECTED) {
      mqttClientWrapper.publishMessage(topic, message);
    } else {
      await initMqtt();
      mqttClientWrapper.publishMessage(topic, message);
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Bạn muốn thoát ứng dụng ?'),
            // content: new Text('Bạn muốn thoát ứng dụng?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('Hủy'),
              ),
              new FlatButton(
                onPressed: () => exit(0),
                // Navigator.of(context).pop(true),
                child: new Text('Đồng ý'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          automaticallyImplyLeading: false,
          title: Text(
            'Máy lọc nước',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.yellow,
        image: DecorationImage(
          image: AssetImage("images/cres_bg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      width: double.infinity,
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 20,
              ),
              liquidProgress(),
              deviceInfo(),
              deleteButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget liquidProgress() {
    return Container(
      width: ScreenHelper.getWidth(context) * 0.7,
      height: ScreenHelper.getWidth(context) * 0.7,
      child: LiquidCircularProgressIndicator(
        value: int.parse(widget.thietBi.TDS) / 100,
        // Defaults to 0.5.
        valueColor: AlwaysStoppedAnimation(Colors.lightBlue),
        // Defaults to the current Theme's accentColor.
        backgroundColor: Colors.white,
        // Defaults to the current Theme's backgroundColor.
        borderColor: Colors.blue,
        borderWidth: 3.0,
        direction: Axis.vertical,
        // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
        center: centerProgress(),
      ),
    );
  }

  Widget deleteButton() {
    return Container(
      height: 36,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 86,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            offset: Offset(1.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: new Text(
                'Xóa thiết bị ?',
              ),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: new Text(
                    'Hủy',
                  ),
                ),
                new FlatButton(
                  onPressed: () {
                    pubTopic = DELETE_TB;
                    var tb = ThietBi(
                        iduser,
                        widget.thietBi.mathietbi,
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        '',
                        Constants.mac);
                    publishMessage(pubTopic, jsonEncode(tb));
                  },
                  child: new Text(
                    'Đồng ý',
                  ),
                ),
              ],
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delete,
              color: Colors.red,
            ),
            Text(
              'Xóa thiết bị',
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget deviceInfo() {
    String trangthai = '';
    switch (widget.thietBi.trangthai) {
      case '1':
        trangthai = 'Lọc';
        break;
      case '2':
        trangthai = 'Xả';
        break;
      case '3':
        trangthai = 'Rửa hóa chất';
        break;
      case '4':
        trangthai = 'Dừng máy';
        break;
      case '5':
        trangthai = 'Mất kết nối';
        break;
      default:
        trangthai = 'Không hoạt động';
        break;
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        navigatorPush(
            context,
            DepartmentListScreen(
              thietBi: widget.thietBi,
              updateCallback: (device) {},
            ));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        child: PhysicalModel(
          color: Colors.white,
          elevation: 5,
          shadowColor: Colors.blue,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                deviceInfoItem('Tình trạng máy: ', trangthai, Colors.green),
                deviceInfoItem('Tên máy: ',
                    widget.thietBi.mathietbi.substring(0, 6), Colors.black),
                deviceInfoItem(
                    'Điện áp: ', widget.thietBi.dienap, Colors.black),
                deviceInfoItem('TDS: ', widget.thietBi.TDS, Colors.black),
                deviceInfoItem(
                    'Số lõi: ', '${widget.thietBi.soloi} lõi', Colors.black),
                deviceInfoItem('Ngày kích hoạt ',
                    widget.thietBi.ngaykichhoat.split(',')[0], Colors.red),
                deviceInfoItem('Thời gian bảo hành ', '3 năm', Colors.red),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget deviceInfoItem(String label, String content, Color color) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, textAlign: TextAlign.left),
          FittedBox(
            fit: BoxFit.contain,
            child: Text(content,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: ScreenHelper.getWidth(context) * .04,
                  color: color,
                  fontWeight: FontWeight.bold,
                )),
          )
        ],
      ),
    );
  }

  Widget centerProgress() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Chỉ số tinh khiết',
              style: TextStyle(fontSize: ScreenHelper.getWidth(context) * .04)),
          Text(widget.thietBi.TDS,
              style: TextStyle(
                  fontSize: 45,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold)),
          Text('Tốt cho sức khỏe',
              style: TextStyle(fontSize: ScreenHelper.getWidth(context) * .04)),
        ],
      ),
    );
  }

  Widget verticalLine() {
    return Container(
      height: double.infinity,
      width: 1,
      color: Colors.grey,
    );
  }

  Widget horizontalLine() {
    return Container(
      height: 1,
      width: double.infinity,
      color: Colors.grey,
    );
  }

  void removeDevice(int index) async {
    setState(() {
      departments.remove(index);
    });
  }

  void handleDepartment(String message) {
    Map responseMap = jsonDecode(message);
    var response = DeviceResponse.fromJson(responseMap);
    print('Device detail screen: $response');
    switch (pubTopic) {
      case DELETE_TB:
        if (response.errorCode == '0') {
          widget.updateCallback(response);
          Navigator.pop(context);
          Navigator.pop(context);
        }
        break;
      default:
        break;
    }
    hideLoadingDialog();
    setState(() {});
  }

  void showLoadingDialog() {
    setState(() {
      isLoading = true;
    });
  }

  void hideLoadingDialog() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
