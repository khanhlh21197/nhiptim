import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:technonhiptim/dialogWidget/edit_device_dialog.dart';
import 'package:technonhiptim/helper/models.dart';
import 'package:technonhiptim/helper/mqttClientWrapper.dart';
import 'package:technonhiptim/model/department.dart';
import 'package:technonhiptim/model/thietbi.dart';
import 'package:technonhiptim/response/device_response.dart';

import '../helper/constants.dart' as Constants;

class FilterElementScreen extends StatefulWidget {
  @override
  _FilterElementScreenState createState() => _FilterElementScreenState();
}

class _FilterElementScreenState extends State<FilterElementScreen> {
  static const GET_DEPARTMENT = 'getdiadiem';
  static const LOGIN_DEVICE = 'getF0';

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  List<ThietBi> tbs = List();
  MQTTClientWrapper mqttClientWrapper;

  String pubTopic;
  int selectedIndex;
  List<Department> departments = List();
  var dropDownItems = [''];

  bool isLoading = true;

  @override
  void initState() {
    initMqtt();

    // tbs.add(ThietBi('Bn001', 'p101', 'Pham Hong Hoai', 'Nam', '19/01/1994', '0987654321', 'Ha Noi', 'mac'));
    // tbs.add(ThietBi('Bn001', 'p101', 'Ngo Quang Hai', 'Nam', '01/09/1997', '0987654321', 'Ha Noi', 'mac'));
    // tbs.add(ThietBi('Bn001', 'p101', 'Pham Thu Thuy', 'Nu', '22/09/1994', '0987654321', 'Ha Noi', 'mac'));
    isLoading = false;
    super.initState();
  }

  Future<void> initMqtt() async {
    mqttClientWrapper = MQTTClientWrapper(
        () => print('Success'), (message) => handleDevice(message));
    await mqttClientWrapper.prepareMqttClient(Constants.mac);
    getDevices();
  }

  void getDevices() async {
    ThietBi t = ThietBi(
      '',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '7',
      '7',
      '7',
      '7',
      '7',
      '7',
      '7',
      '7',
      '7',
      '7',
      '7',
      '7',
      '7',
      Constants.mac,
    );
    pubTopic = LOGIN_DEVICE;
    publishMessage(pubTopic, jsonEncode(t));
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

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('B???n mu???n tho??t ???ng d???ng ?'),
            // content: new Text('B???n mu???n tho??t ???ng d???ng?'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('H???y'),
              ),
              new FlatButton(
                onPressed: () => exit(0),
                // Navigator.of(context).pop(true),
                child: new Text('?????ng ??'),
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
          actions: [],
          title: Text(
            'Danh s??ch b???nh nh??n',
            style: TextStyle(color: Colors.white),
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
      child: Column(
        children: [
          SizedBox(
            height: 1,
          ),
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
          SizedBox(
            width: 1,
          ),
          verticalLine(),
          buildTextLabel('STT', 1),
          verticalLine(),
          buildTextLabel('H??? v?? t??n', 4),
          verticalLine(),
          buildTextLabel('Ng??y sinh', 3),
          verticalLine(),
          buildTextLabel('Gi???i t??nh', 2),
          verticalLine(),
          SizedBox(
            width: 1,
          ),
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
          itemCount: tbs.length,
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
        selectedIndex = index;
        Department d = Department('', '', Constants.mac);
        pubTopic = GET_DEPARTMENT;
        publishMessage(pubTopic, jsonEncode(d));
        showLoadingDialog();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: Column(
          children: [
            Container(
              height: 40,
              child: Row(
                children: [
                  SizedBox(
                    width: 1,
                  ),
                  verticalLine(),
                  buildTextData('${index + 1}', 1),
                  verticalLine(),
                  buildTextData(tbs[index].vitri, 4),
                  verticalLine(),
                  // buildTextData(tbs[index].ngaysinh, 3),
                  verticalLine(),
                  // buildTextData(tbs[index].gioitinh, 2),
                  verticalLine(),
                  SizedBox(
                    width: 1,
                  ),
                ],
              ),
            ),
            horizontalLine(),
          ],
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
      tbs.removeAt(index);
    });
  }

  void handleDevice(String message) async {
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
        print('_DeviceListScreenState.handleDevice ${dropDownItems.length}');

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
                      EditDeviceDialog(
                        thietbi: tbs[selectedIndex],
                        dropDownItems: dropDownItems,
                        deleteCallback: (param) {
                          getDevices();
                        },
                        updateCallback: (updatedDevice) {
                          getDevices();
                        },
                      ),
                      Positioned(
                        right: 0.0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            getDevices();
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

        break;
      case LOGIN_DEVICE:
        tbs = response.id.map((e) => ThietBi.fromJson(e)).toList();
        setState(() {});
        hideLoadingDialog();
        break;
    }
    pubTopic = '';
  }

  @override
  void dispose() {
    super.dispose();
  }
}
