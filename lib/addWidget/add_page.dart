import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:technonhiptim/addWidget/add_camera_page.dart';
import 'package:technonhiptim/addWidget/add_department_page.dart';
import 'package:technonhiptim/addWidget/add_device_page.dart';
import 'package:technonhiptim/helper/models.dart';
import 'package:technonhiptim/helper/mqttClientWrapper.dart';
import 'package:technonhiptim/helper/shared_prefs_helper.dart';
import 'package:technonhiptim/model/department.dart';
import 'package:technonhiptim/model/thietbi.dart';
import 'package:technonhiptim/navigator.dart';
import 'package:technonhiptim/response/device_response.dart';

import '../helper/constants.dart' as Constants;

class AddScreen extends StatefulWidget {
  const AddScreen({
    Key key,
  }) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  static const GET_DEPARTMENT = 'getdiadiem';
  static const GET_BENHNHAN = 'getF0';

  String pubTopic;

  MQTTClientWrapper mqttClientWrapper;
  SharedPrefsHelper sharedPrefsHelper;
  List<Department> departments = List();
  List<ThietBi> benhnhans = List();
  List<String> dropDownItems = List();
  List<String> dropBenhNhan = List();

  bool isLoading = false;

  @override
  void initState() {
    // showLoadingDialog();
    initMqtt();
    super.initState();
  }

  Future<void> initMqtt() async {
    mqttClientWrapper =
        MQTTClientWrapper(() => print('Success'), (message) => handle(message));
    await mqttClientWrapper.prepareMqttClient(Constants.mac);

    // Department d = Department('', '', Constants.mac);
    // publishMessage(GET_DEPARTMENT, jsonEncode(d));

    getDevices();

    Future.delayed(Duration(seconds: 1), () {
      getDepartment();
    });
  }

  void getDevices() async {
    ThietBi tb = ThietBi(
      'iduser',
      'idController.text',
      'vitriController.text',
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      Constants.mac,
    );
    pubTopic = GET_BENHNHAN;
    publishMessage(pubTopic, jsonEncode(tb));
    showLoadingDialog();
  }

  void getDepartment() async {
    Department d = Department('', '', Constants.mac);
    pubTopic = GET_DEPARTMENT;
    publishMessage(pubTopic, jsonEncode(d));
    showLoadingDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Th??m',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body:
          isLoading ? Center(child: CircularProgressIndicator()) : buildBody(),
      // buildBody(),
    );
  }

  Widget buildBody() {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          // buildButton('Th??m b???nh nh??n ', Icons.accessibility_new, 1),
          // horizontalLine(),
          // buildButton('Th??m ph??ng', Icons.devices, 2),
          horizontalLine(),
          buildButton(
              'Th??m thi???t b???', Icons.airline_seat_individual_suite_rounded, 3),
        ],
      ),
    );
  }

  Widget horizontalLine() {
    return Container(height: 1, width: double.infinity, color: Colors.grey);
  }

  Widget buildButton(String text, IconData icon, int option) {
    return GestureDetector(
      onTap: () {
        switch (option) {
          case 1:
            navigatorPush(
                context,
                AddDeviceScreen(
                  dropDownItems: dropDownItems,
                ));
            break;
          case 2:
            navigatorPush(context, AddDepartmentScreen());
            break;
          case 3:
            navigatorPush(
                context,
                AddCameraScreen(
                  dropDownItems: dropDownItems,
                  dropBenhNhan: dropBenhNhan,
                ));
        }
      },
      child: Container(
        height: 80,
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            Icon(
              icon,
              size: 25,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }

  void handle(String message) {
    Map responseMap = jsonDecode(message);
    var response = DeviceResponse.fromJson(responseMap);
    switch (pubTopic) {
      case GET_DEPARTMENT:
        departments = response.id.map((e) => Department.fromJson(e)).toList();
        dropDownItems.clear();
        departments.forEach((element) {
          dropDownItems.add(element.maphong);
        });
        hideLoadingDialog();
        print('_AddScreenState.handle dia diem ${dropDownItems[0]}');
        break;
      case GET_BENHNHAN:
        benhnhans = response.id.map((e) => ThietBi.fromJson(e)).toList();
        dropBenhNhan.clear();
        benhnhans.forEach((element) {
          dropBenhNhan.add(element.mathietbi);
        });
        hideLoadingDialog();
        print('_AddScreenState.handle nguoi ${dropBenhNhan.length}');
        break;
    }
    hideLoadingDialog();
    print('_AddScreenState.handle ${dropDownItems.length}');
  }

  void showLoadingDialog() {
    setState(() {
      isLoading = true;
    });
    // Dialogs.showLoadingDialog(context, _keyLoader);
  }

  void hideLoadingDialog() {
    setState(() {
      isLoading = false;
    });
    // Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
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
}
