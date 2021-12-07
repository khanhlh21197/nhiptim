import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:technonhiptim/helper/models.dart';
import 'package:technonhiptim/helper/mqttClientWrapper.dart';
import 'package:technonhiptim/helper/shared_prefs_helper.dart';
import 'package:technonhiptim/login/login_page.dart';
import 'package:technonhiptim/model/nguoidung.dart';
import 'package:technonhiptim/model/thietbi.dart';
import 'package:technonhiptim/response/nguoi_dung_response.dart';
import '../helper/constants.dart' as Constants;

import '../navigator.dart';

class BenhNhan extends StatefulWidget {
  const BenhNhan({
    Key key,
  }) : super(key: key);

  @override
  _BenhNhanState createState() => _BenhNhanState();
}

class _BenhNhanState extends State<BenhNhan> {
  static const GET_TIMKIEM = 'getbenhnhantheoma';
  List<NguoiDung> peoples = List();
  MQTTClientWrapper mqttClientWrapper;
  SharedPrefsHelper sharedPrefsHelper;
  String pubTopic;
  var mabenhnhan;
  int selectedIndex;
  bool isLoading = true;

  void initState() {
    sharedPrefsHelper = SharedPrefsHelper();
    initMqtt();
    isLoading = false;
    super.initState();
  }

  Future<void> initMqtt() async {
    mqttClientWrapper = MQTTClientWrapper(
        () => print('Success'), (message) => handleDevice(message));
    await mqttClientWrapper.prepareMqttClient(Constants.mac);
    mabenhnhan = await sharedPrefsHelper.getStringValuesSF('email');
    print('_BenhNhanState.initMqtt $mabenhnhan');
    getDevices();
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

  void getDevices() async {
    NguoiDung peoples =
        NguoiDung('', mabenhnhan, '', '', '', '', '', '', Constants.mac);
    pubTopic = GET_TIMKIEM;
    publishMessage(pubTopic, jsonEncode(peoples));
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
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  navigatorPushAndRemoveUntil(context, LoginPage());
                }),
          ],
          title: Text('Giám Sát'),
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
          horizontalLine(),
          buildTableTitle(),
          horizontalLine(),
          buildListView(),
          horizontalLine(),
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
          buildTextLabel('Họ tên', 3),
          verticalLine(),
          buildTextLabel('Mã bn', 1),
          verticalLine(),
          buildTextLabel('Mã ph', 1),
          verticalLine(),
          buildTextLabel('Nđộ', 1),
          verticalLine(),
          buildTextLabel('Ntim', 1),
          verticalLine(),
          buildTextLabel('Nđ oxy', 1),
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
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
          itemCount: peoples.length,
          itemBuilder: (context, index) {
            return itemView(index);
          },
        ),
      ),
    );
  }

  Widget itemView(int index) {
    return InkWell(
      onTap: () async {},
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
                  Expanded(
                    child: Text(
                      peoples[index].hoten ?? '0',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    flex: 3,
                  ),
                  verticalLine(),
                  Expanded(
                    child: Text(
                      peoples[index].magiamsat ?? '0',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    flex: 1,
                  ),
                  verticalLine(),
                  Expanded(
                    child: Text(
                      peoples[index].madiadiem ?? '0',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    flex: 1,
                  ),
                  verticalLine(),
                  Expanded(
                    child: Text(
                      peoples[index].nhietdo ?? '0',
                      style: TextStyle(
                        fontSize: 18,
                        color: peoples[index].color ?? Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    flex: 1,
                  ),
                  verticalLine(),
                  Expanded(
                    child: Text(
                      peoples[index].nhiptim ?? '0',
                      style: TextStyle(
                          fontSize: 18,
                          color: peoples[index].color1 ?? Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    flex: 1,
                  ),
                  verticalLine(),
                  Expanded(
                    child: Text(
                      peoples[index].nongdooxy ?? '0',
                      style: TextStyle(
                          fontSize: 18,
                          color: peoples[index].color2 ?? Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    flex: 1,
                  ),
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

  Widget buildTextData(ThietBi people, String data, int flexValue) {
    return Expanded(
      child: Text(
        data,
        style: TextStyle(fontSize: 18, color: people.color ?? Colors.black),
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

  void handleDevice(String message) async {
    Map responseMap = jsonDecode(message);
    var response = NguoiDungResponse.fromJson(responseMap);

    switch (pubTopic) {
      case GET_TIMKIEM:
        peoples = response.id.map((e) => NguoiDung.fromJson(e)).toList();
        setState(() {});
        peoples.forEach((element) {
          if (double.tryParse(element.nhietdo) > 37.5) {
            element.color = Colors.red;
            setState(() {});
          }
          if (double.tryParse(element.nhiptim) > 100) {
            element.color1 = Colors.red;
            setState(() {});
          }
          if (double.tryParse(element.nongdooxy) < 95) {
            element.color2 = Colors.red;
            setState(() {});
          }
        });
        hideLoadingDialog();
        break;
    }
    pubTopic = '';
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

  @override
  void dispose() {
    super.dispose();
  }
}
