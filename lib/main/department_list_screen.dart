import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:technonhiptim/helper/loader.dart';
import 'package:technonhiptim/helper/models.dart';
import 'package:technonhiptim/helper/mqttClientWrapper.dart';
import 'package:technonhiptim/model/department.dart';
import 'package:technonhiptim/model/loi.dart';
import 'package:technonhiptim/model/thietbi.dart';
import 'package:technonhiptim/response/device_response.dart';

import '../helper/constants.dart' as Constants;

class DepartmentListScreen extends StatefulWidget {
  final ThietBi thietBi;
  final Function(dynamic) updateCallback;

  const DepartmentListScreen({
    Key key,
    this.thietBi,
    this.updateCallback,
  }) : super(key: key);

  @override
  _DepartmentListScreenState createState() => _DepartmentListScreenState();
}

class _DepartmentListScreenState extends State<DepartmentListScreen> {
  static const RESET_LOI = 'resetloi';

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List<Department> departments = List();
  MQTTClientWrapper mqttClientWrapper;

  String pubTopic;
  int resetLoiIndex = 0;
  List<Loi> listLoi = new List();

  bool isLoading = true;

  @override
  void initState() {
    ThietBi tb = widget.thietBi;

    if (tb.Loi1 != "0") {
      listLoi.add(Loi('Lõi 1', tb.Loi1.split(',')[0], tb.Loi1.split(',')[1],
          'Loi1', widget.thietBi.mathietbi, Constants.mac));
    }
    if (tb.Loi2 != "0") {
      listLoi.add(Loi('Lõi 2', tb.Loi2.split(',')[0], tb.Loi2.split(',')[1],
          'Loi1', widget.thietBi.mathietbi, Constants.mac));
    }
    if (tb.Loi3 != "0") {
      listLoi.add(Loi('Lõi 3', tb.Loi3.split(',')[0], tb.Loi3.split(',')[1],
          'Loi1', widget.thietBi.mathietbi, Constants.mac));
    }
    if (tb.Loi4 != "0") {
      listLoi.add(Loi('Lõi 4', tb.Loi4.split(',')[0], tb.Loi4.split(',')[1],
          'Loi1', widget.thietBi.mathietbi, Constants.mac));
    }
    if (tb.Loi5 != "0") {
      listLoi.add(Loi('Lõi 5', tb.Loi5.split(',')[0], tb.Loi5.split(',')[1],
          'Loi1', widget.thietBi.mathietbi, Constants.mac));
    }
    if (tb.Loi6 != "0") {
      listLoi.add(Loi('Lõi 6', tb.Loi6.split(',')[0], tb.Loi6.split(',')[1],
          'Loi1', widget.thietBi.mathietbi, Constants.mac));
    }
    if (tb.Loi7 != "0") {
      listLoi.add(Loi('Lõi 7', tb.Loi7.split(',')[0], tb.Loi7.split(',')[1],
          'Loi1', widget.thietBi.mathietbi, Constants.mac));
    }
    if (tb.Loi8 != "0") {
      listLoi.add(Loi('Lõi 8', tb.Loi8.split(',')[0], tb.Loi8.split(',')[1],
          'Loi1', widget.thietBi.mathietbi, Constants.mac));
    }
    if (tb.Loi9 != "0") {
      listLoi.add(Loi('Lõi 9', tb.Loi9.split(',')[0], tb.Loi9.split(',')[1],
          'Loi1', widget.thietBi.mathietbi, Constants.mac));
    }
    if (tb.Loi10 != "0") {
      listLoi.add(Loi('Lõi 10', tb.Loi10.split(',')[0], tb.Loi10.split(',')[1],
          'Loi1', widget.thietBi.mathietbi, Constants.mac));
    }
    if (tb.Loi11 != "0") {
      listLoi.add(Loi('Lõi 11', tb.Loi11.split(',')[0], tb.Loi11.split(',')[1],
          'Loi1', widget.thietBi.mathietbi, Constants.mac));
    }
    if (tb.Loi12 != "0") {
      listLoi.add(Loi('Lõi 12', tb.Loi12.split(',')[0], tb.Loi12.split(',')[1],
          'Loi1', widget.thietBi.mathietbi, Constants.mac));
    }
    isLoading = false;

    initMqtt();
    super.initState();
  }

  Future<void> initMqtt() async {
    mqttClientWrapper = MQTTClientWrapper(
        () => print('Success'), (message) => handleDepartment(message));
    await mqttClientWrapper.prepareMqttClient(Constants.mac);
  }

  void _tryResetLoi(Loi loi) {
    pubTopic = RESET_LOI;
    publishMessage(pubTopic, jsonEncode(loi));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: false,
        title: Text(
          'Danh sách lõi lọc',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/cres_bg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      // color: Colors.white,
      child: Column(
        children: [
          buildListView(),
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
          itemCount: listLoi.length,
          itemBuilder: (context, index) {
            return itemView(listLoi[index]);
          },
        ),
      ),
    );
  }

  Widget itemView(Loi loi) {
    return InkWell(
      onTap: () async {
        // navigatorPush(
        //     context,
        //     GiamSat(
        //       madiadiem: departments[index].maphong,
        //     ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 1),
        margin: const EdgeInsets.all(8),
        child: PhysicalModel(
          color: Colors.white.withOpacity(0.9),
          elevation: 5,
          shadowColor: Colors.white,
          borderRadius: BorderRadius.circular(5),
          child: Row(children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    child: Image.asset(
                      'images/logo.png',
                    ),
                  ),
                  Expanded(child: elementInfo(loi)),
                  reloadButton(loi),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget elementIcon(Loi loi) {
    return Container(
      margin: const EdgeInsets.all(4),
      width: 30,
      height: 30,
      child: LiquidLinearProgressIndicator(
        value: 0.5,
        // Defaults to 0.5.
        valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
        // Defaults to the current Theme's accentColor.
        backgroundColor: Colors.white,
        // Defaults to the current Theme's backgroundColor.
        borderColor: Colors.blueAccent,
        borderWidth: 3.0,
        borderRadius: 15.0,
        direction: Axis.vertical,
        // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
      ),
    );
  }

  Widget elementInfo(Loi loi) {
    DateTime tempDate = new DateFormat("MM/dd/yyyy").parse(loi.ngay);
    final date2 = DateTime.now();
    final difference = tempDate.difference(date2).inDays + 1;

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loi.ten,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Text('Thời gian còn lại $difference ngày'),
          SizedBox(
            height: 5,
          ),
          Container(
            color: Colors.yellow,
            height: 10,
            width: 300,
            child: LiquidLinearProgressIndicator(
              value: difference / 90 * 100,
              // Defaults to 0.5.
              valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
              // Defaults to the current Theme's accentColor.
              backgroundColor: Colors.white,
              // Defaults to the current Theme's backgroundColor.
              borderColor: Colors.blueAccent,
              borderWidth: 3.0,
              borderRadius: 12.0,
              direction: Axis.horizontal,
              // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
            ),
          ),
        ],
      ),
    );
  }

  Widget reloadButton(Loi loi) {
    return InkWell(
      onTap: () async {
        await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Bạn muốn reset ${loi.ten}?'),
            // content: new Text('Bạn muốn thoát ứng dụng?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('Hủy'),
              ),
              new FlatButton(
                onPressed: () {
                  _tryResetLoi(loi);
                  resetLoiIndex = listLoi.indexOf(loi);
                  Navigator.of(context).pop(false);
                },
                // Navigator.of(context).pop(true),
                child: new Text('Đồng ý'),
              ),
            ],
          ),
        );
      },
      child: Container(
        child: IconButton(
          icon: Image.asset(
            'images/refresh.png',
            width: 25,
            height: 25,
            color: Colors.yellow,
          ),
          onPressed: null,
        ),
      ),
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

  void handleDepartment(String message) {
    Map responseMap = jsonDecode(message);
    var response = DeviceResponse.fromJson(responseMap);

    switch (pubTopic) {
      case RESET_LOI:
        if (response.errorCode == '0') {
          _showToast(context, 'Reset lõi thành công');

          // final newDate = DateTime.now().add(const Duration(days: 90));
          // listLoi[resetLoiIndex].ngay = new DateFormat("MM/dd/yyyy").parse(newDate.toString()).toString();
          // DateTime tempDate = new DateFormat("MM/dd/yyyy").parse(loi.ngay);

          var tbs = response.id.map((e) => ThietBi.fromJson(e)).toList();

          var tb = tbs[0];
          print('Thiet Bi: $tb');
          if (tb != null) listLoi = new List();
          if (tb.Loi1 != "0") {
            listLoi.add(Loi(
                'Lõi 1',
                tb.Loi1.split(',')[0],
                tb.Loi1.split(',')[1],
                'Loi1',
                widget.thietBi.mathietbi,
                Constants.mac));
          }
          if (tb.Loi2 != "0") {
            listLoi.add(Loi(
                'Lõi 2',
                tb.Loi2.split(',')[0],
                tb.Loi2.split(',')[1],
                'Loi1',
                widget.thietBi.mathietbi,
                Constants.mac));
          }
          if (tb.Loi3 != "0") {
            listLoi.add(Loi(
                'Lõi 3',
                tb.Loi3.split(',')[0],
                tb.Loi3.split(',')[1],
                'Loi1',
                widget.thietBi.mathietbi,
                Constants.mac));
          }
          if (tb.Loi4 != "0") {
            listLoi.add(Loi(
                'Lõi 4',
                tb.Loi4.split(',')[0],
                tb.Loi4.split(',')[1],
                'Loi1',
                widget.thietBi.mathietbi,
                Constants.mac));
          }
          if (tb.Loi5 != "0") {
            listLoi.add(Loi(
                'Lõi 5',
                tb.Loi5.split(',')[0],
                tb.Loi5.split(',')[1],
                'Loi1',
                widget.thietBi.mathietbi,
                Constants.mac));
          }
          if (tb.Loi6 != "0") {
            listLoi.add(Loi(
                'Lõi 6',
                tb.Loi6.split(',')[0],
                tb.Loi6.split(',')[1],
                'Loi1',
                widget.thietBi.mathietbi,
                Constants.mac));
          }
          if (tb.Loi7 != "0") {
            listLoi.add(Loi(
                'Lõi 7',
                tb.Loi7.split(',')[0],
                tb.Loi7.split(',')[1],
                'Loi1',
                widget.thietBi.mathietbi,
                Constants.mac));
          }
          if (tb.Loi8 != "0") {
            listLoi.add(Loi(
                'Lõi 8',
                tb.Loi8.split(',')[0],
                tb.Loi8.split(',')[1],
                'Loi1',
                widget.thietBi.mathietbi,
                Constants.mac));
          }
          if (tb.Loi9 != "0") {
            listLoi.add(Loi(
                'Lõi 9',
                tb.Loi9.split(',')[0],
                tb.Loi9.split(',')[1],
                'Loi1',
                widget.thietBi.mathietbi,
                Constants.mac));
          }
          if (tb.Loi10 != "0") {
            listLoi.add(Loi(
                'Lõi 10',
                tb.Loi10.split(',')[0],
                tb.Loi10.split(',')[1],
                'Loi1',
                widget.thietBi.mathietbi,
                Constants.mac));
          }
          if (tb.Loi11 != "0") {
            listLoi.add(Loi(
                'Lõi 11',
                tb.Loi11.split(',')[0],
                tb.Loi11.split(',')[1],
                'Loi1',
                widget.thietBi.mathietbi,
                Constants.mac));
          }
          if (tb.Loi12 != "0") {
            listLoi.add(Loi(
                'Lõi 12',
                tb.Loi12.split(',')[0],
                tb.Loi12.split(',')[1],
                'Loi1',
                widget.thietBi.mathietbi,
                Constants.mac));
          }
          isLoading = false;
          setState(() {});
        } else {
          _showToast(context, 'Reset lõi thất bại');
        }
        break;
      default:
        break;
    }

    print('$response');
    hideLoadingDialog();
    setState(() {});
  }

  void _showToast(BuildContext context, String message) {
    Dialogs.showAlertDialog(context, message);
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
