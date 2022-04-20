import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:technonhiptim/dialogWidget/edit_department_dialog.dart';
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
  static const LOGIN_KHOA = 'getdiadiem';

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List<Department> departments = List();
  MQTTClientWrapper mqttClientWrapper;

  String pubTopic;
  List<Loi> listLoi = new List();

  bool isLoading = true;

  @override
  void initState() {
    ThietBi tb = widget.thietBi;

    if (tb.Loi1 != "0") {
      listLoi.add(Loi('Lõi 1', tb.Loi1.split(',')[0], tb.Loi1.split(',')[1]));
    }
    if (tb.Loi2 != "0") {
      listLoi.add(Loi('Lõi 2', tb.Loi2.split(',')[0], tb.Loi2.split(',')[1]));
    }
    if (tb.Loi3 != "0") {
      listLoi.add(Loi('Lõi 3', tb.Loi3.split(',')[0], tb.Loi3.split(',')[1]));
    }
    if (tb.Loi4 != "0") {
      listLoi.add(Loi('Lõi 4', tb.Loi4.split(',')[0], tb.Loi4.split(',')[1]));
    }
    if (tb.Loi5 != "0") {
      listLoi.add(Loi('Lõi 5', tb.Loi5.split(',')[0], tb.Loi5.split(',')[1]));
    }
    if (tb.Loi6 != "0") {
      listLoi.add(Loi('Lõi 6', tb.Loi6.split(',')[0], tb.Loi6.split(',')[1]));
    }
    if (tb.Loi7 != "0") {
      listLoi.add(Loi('Lõi 7', tb.Loi7.split(',')[0], tb.Loi7.split(',')[1]));
    }
    if (tb.Loi8 != "0") {
      listLoi.add(Loi('Lõi 8', tb.Loi8.split(',')[0], tb.Loi8.split(',')[1]));
    }
    if (tb.Loi9 != "0") {
      listLoi.add(Loi('Lõi 9', tb.Loi9.split(',')[0], tb.Loi9.split(',')[1]));
    }
    if (tb.Loi10 != "0") {
      listLoi
          .add(Loi('Lõi 10', tb.Loi10.split(',')[0], tb.Loi10.split(',')[1]));
    }
    if (tb.Loi11 != "0") {
      listLoi
          .add(Loi('Lõi 11', tb.Loi11.split(',')[0], tb.Loi11.split(',')[1]));
    }
    if (tb.Loi12 != "0") {
      listLoi
          .add(Loi('Lõi 12', tb.Loi12.split(',')[0], tb.Loi12.split(',')[1]));
    }
    isLoading = false;

    initMqtt();
    super.initState();
  }

  Future<void> initMqtt() async {
    mqttClientWrapper = MQTTClientWrapper(
        () => print('Success'), (message) => handleDepartment(message));
    await mqttClientWrapper.prepareMqttClient(Constants.mac);
    getDepartments();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: false,
        title: Text(
          'Danh sách lõi loc',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          // IconButton(
          //     icon: Icon(
          //       Icons.logout,
          //       color: Colors.black,
          //     ),
          //     onPressed: () {
          //       navigatorPushAndRemoveUntil(context, LoginPage());
          //     }),
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Container(
      color: Colors.white,
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
          color: Colors.white,
          elevation: 5,
          shadowColor: Colors.white,
          borderRadius: BorderRadius.circular(5),
          child: Row(children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: elementIcon(loi)),
                  Expanded(child: elementInfo(loi)),
                  Expanded(child: reloadButton(loi)),
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
      margin: const EdgeInsets.all(8),
      width: 15,
      height: 30,
      child: LiquidLinearProgressIndicator(
        value: 0.6,
        // Defaults to 0.5.
        valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
        // Defaults to the current Theme's accentColor.
        backgroundColor: Colors.white,
        // Defaults to the current Theme's backgroundColor.
        borderColor: Colors.blueAccent,
        borderWidth: 3.0,
        borderRadius: 12.0,
        direction: Axis.vertical,
        // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
      ),
    );
  }

  Widget elementInfo(Loi loi) {
    DateTime tempDate = new DateFormat("MM/dd/yyyy").parse(loi.ngay);
    final date2 = DateTime.now();
    final difference = tempDate.difference(date2).inDays;

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
    return Container(
      child: IconButton(
        icon: Image.asset(
          'images/refresh.png',
          width: 25,
          height: 25,
          color: Colors.yellow,
        ),
        onPressed: null,
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
