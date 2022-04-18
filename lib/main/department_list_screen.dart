import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:technonhiptim/dialogWidget/edit_department_dialog.dart';
import 'package:technonhiptim/helper/models.dart';
import 'package:technonhiptim/helper/mqttClientWrapper.dart';
import 'package:technonhiptim/login/login_page.dart';
import 'package:technonhiptim/model/department.dart';
import 'package:technonhiptim/navigator.dart';
import 'package:technonhiptim/response/device_response.dart';

import '../helper/constants.dart' as Constants;

class DepartmentListScreen extends StatefulWidget {
  @override
  _DepartmentListScreenState createState() => _DepartmentListScreenState();
}

class _DepartmentListScreenState extends State<DepartmentListScreen> {
  static const LOGIN_KHOA = 'getdiadiem';

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List<Department> departments = List();
  MQTTClientWrapper mqttClientWrapper;

  String pubTopic;

  bool isLoading = true;

  @override
  void initState() {
    departments.add(Department('Loi so 101', 'p101', 'mac'));
    departments.add(Department('Loi so 102', 'p102', 'mac'));
    departments.add(Department('Loi so 103', 'p103', 'mac'));
    departments.add(Department('Loi so 103', 'p103', 'mac'));
    departments.add(Department('Loi so 103', 'p103', 'mac'));
    departments.add(Department('Loi so 103', 'p103', 'mac'));
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          automaticallyImplyLeading: false,
          title: Text(
            'Danh sách phòng',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
                onPressed: () {
                  navigatorPushAndRemoveUntil(context, LoginPage());
                }),
          ],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : buildBody(),
      ),
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
          itemCount: departments.length,
          itemBuilder: (context, index) {
            return itemView(departments[index]);
          },
        ),
      ),
    );
  }

  Widget itemView(Department department) {
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
          elevation: 3,
          shadowColor: Colors.white,
          borderRadius: BorderRadius.circular(5),
          child: Row(children: [
            Expanded(
              child: Row(
                children: [
                  elementIcon(department),
                  elementInfo(department),
                  reloadButton(department),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget elementIcon(Department department) {
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

  Widget elementInfo(Department department) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            department.tenphong,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Text('Thời gian còn lại của lõi: 1200/1200 giờ'),
          SizedBox(
            height: 5,
          ),
          Container(
            color: Colors.yellow,
            height: 10,
            width: 300,
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
              direction: Axis.horizontal,
              // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
            ),
          ),
        ],
      ),
    );
  }

  Widget reloadButton(Department department) {
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
