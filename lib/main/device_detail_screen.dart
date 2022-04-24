import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:technonhiptim/dialogWidget/edit_department_dialog.dart';
import 'package:technonhiptim/helper/media_query_helper.dart';
import 'package:technonhiptim/helper/models.dart';
import 'package:technonhiptim/helper/mqttClientWrapper.dart';
import 'package:technonhiptim/main/department_list_screen.dart';
import 'package:technonhiptim/main/giamsat.dart';
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
  static const LOGIN_KHOA = 'getdiadiem';

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List<Department> departments = List();
  MQTTClientWrapper mqttClientWrapper;

  String pubTopic;
  bool isLoading = true;

  @override
  void initState() {
    isLoading = false;
    initMqtt();

    super.initState();
  }

  Future<void> initMqtt() async {
    mqttClientWrapper = MQTTClientWrapper(
        () => print('Success'), (message) => handleDepartment(message));
    await mqttClientWrapper.prepareMqttClient(Constants.mac);

    mqttClientWrapper.subscribe(widget.thietBi.mathietbi, (_message) {
      print('_DetailScreenState.initMqtt $_message');
      var result = _message.replaceAll("\"", "").split('&');
      String trangthai = '';

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
    });
    // getDepartments();
  }

  void getDepartments() {
    Department department = Department('', '', Constants.mac);
    pubTopic = LOGIN_KHOA;
    publishMessage(pubTopic, jsonEncode(department));
    showLoadingDialog();
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
          // actions: [
          //   IconButton(
          //       icon: Icon(
          //         Icons.edit,
          //         color: Colors.black,
          //       ),
          //       onPressed: () {
          //         navigatorPushAndRemoveUntil(context, EditDeviceDialog(
          //           thietbi: tbs[selectedIndex],
          //           dropDownItems: dropDownItems,
          //           deleteCallback: (param) {
          //             getDevices();
          //           },
          //           updateCallback: (updatedDevice) {
          //             getDevices();
          //           },
          //         ),);
          //       }),
          // ],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : buildBody(),
      ),
    );
  }

  // void getDevices() async {
  //   ThietBi t = ThietBi(
  //     '1',
  //     '2',
  //     '3',
  //     '4',
  //     '5',
  //     '6',
  //     '7',
  //     Constants.mac,
  //   );
  //   pubTopic = LOGIN_DEVICE;
  //   publishMessage(pubTopic, jsonEncode(t));
  //   showLoadingDialog();
  // }

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
        value: 0.25,
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
          Text('12',
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

  Widget buildTableTitle() {
    return Container(
      // color: Colors.yellow,
      height: 40,
      child: Row(
        children: [
          buildTextLabel('STT', 1),
          verticalLine(),
          buildTextLabel('Mã', 3),
          verticalLine(),
          buildTextLabel('Ví trí', 3),
          verticalLine(),
          // buildTextLabel('Sđt', 3),
          // verticalLine(),
          buildTextLabel('Sửa', 1),
        ],
      ),
    );
  }

  Widget buildTextLabel(String data, int flexValue) {
    return Expanded(
      child: Text(
        data,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      flex: flexValue,
    );
  }

  Widget buildListView() {
    return Container(
      child: Expanded(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: departments.length,
          itemBuilder: (context, index) {
            return itemView(index);
          },
        ),
      ),
    );
  }

  Widget itemView(int index) {
    return InkWell(
      onTap: () async {
        navigatorPush(
            context,
            GiamSat(
              madiadiem: departments[index].maphong,
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: Column(
          children: [
            Container(
              height: 40,
              child: Row(
                children: [
                  buildTextData('${index + 1}', 1),
                  verticalLine(),
                  buildTextData(departments[index].maphong ?? '', 3),
                  verticalLine(),
                  buildTextData(departments[index].tenphong ?? '', 3),
                  verticalLine(),
                  buildEditBtn(index, 1),
                ],
              ),
            ),
            horizontalLine(),
          ],
        ),
      ),
    );
  }

  Widget buildEditBtn(int index, int flex) {
    return Expanded(
      child: IconButton(
          icon: Icon(
            Icons.edit,
            color: Colors.black,
          ),
          onPressed: () async {
            await showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    //this right here
                    child: Container(
                      child: Stack(
                        children: [
                          EditDepartmentDialog(
                            department: departments[index],
                            editCallback: (department) {
                              print(
                                  '_DepartmentListScreenState.itemView $department');
                              getDepartments();
                            },
                            deleteCallback: (a) {
                              getDepartments();
                            },
                          ),
                          Positioned(
                            right: 0.0,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                getDepartments();
                              },
                              child: Align(
                                alignment: Alignment.topRight,
                                child: CircleAvatar(
                                  radius: 14.0,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.close, color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }),
      flex: flex,
    );
  }

  Widget buildTextData(String data, int flexValue) {
    return Expanded(
      child: Text(
        data,
        style: TextStyle(fontSize: 18),
        textAlign: TextAlign.center,
      ),
      flex: flexValue,
    );
  }

  Widget buildStatusDevice(bool data, int flexValue) {
    return Expanded(
      child: data
          ? Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
            )
          : Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
            ),
      flex: flexValue,
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

    departments = response.id.map((e) => Department.fromJson(e)).toList();
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
