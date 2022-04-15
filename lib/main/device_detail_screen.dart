import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:technonhiptim/dialogWidget/edit_department_dialog.dart';
import 'package:technonhiptim/helper/models.dart';
import 'package:technonhiptim/helper/mqttClientWrapper.dart';
import 'package:technonhiptim/login/login_page.dart';
import 'package:technonhiptim/main/giamsat.dart';
import 'package:technonhiptim/model/department.dart';
import 'package:technonhiptim/navigator.dart';
import 'package:technonhiptim/response/device_response.dart';

import '../helper/constants.dart' as Constants;

class DeviceDetailScreen extends StatefulWidget {
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
    departments.add(Department('phong 101', 'p101', 'mac'));
    departments.add(Department('phong 102', 'p102', 'mac'));
    departments.add(Department('phong 103', 'p103', 'mac'));
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
      onWillPop: null,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          automaticallyImplyLeading: false,
          title: Text(
            'Máy lọc nước của User',
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
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          liquidProgress(),
          deviceInfo(),
          Image.asset(
            'images/water_filter.png',
            width: 300,
            height: 150,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  Widget liquidProgress() {
    return Container(
      width: 250,
      height: 250,
      child: LiquidCircularProgressIndicator(
        value: 0.25,
        // Defaults to 0.5.
        valueColor: AlwaysStoppedAnimation(Colors.lightBlue),
        // Defaults to the current Theme's accentColor.
        backgroundColor: Colors.white,
        // Defaults to the current Theme's backgroundColor.
        borderColor: Colors.blue,
        borderWidth: 5.0,
        direction: Axis.vertical,
        // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
        center: centerProgress(),
      ),
    );
  }

  Widget deviceInfo() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: PhysicalModel(
        color: Colors.white,
        elevation: 5,
        shadowColor: Colors.blue,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              deviceInfoItem(
                  'Tình trạng máy: ', 'Hoạt động ổn định', Colors.green),
              deviceInfoItem(
                  'Tên máy: ', 'Máy lọc nước Karofi', Colors.black),
              deviceInfoItem(
                  'Số lõi: ', '8 lõi', Colors.black),
              deviceInfoItem(
                  'Thời gian bảo hành: ', 'Chưa kích hoạt', Colors.red),
            ],
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
          Text(content,
              textAlign: TextAlign.right,
              style: TextStyle(color: color, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget centerProgress() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Chỉ số tinh khiết', style: TextStyle(fontSize: 15)),
          Text('12', style: TextStyle(fontSize: 25)),
          Text('Tốt cho sức khỏe', style: TextStyle(fontSize: 15)),
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
