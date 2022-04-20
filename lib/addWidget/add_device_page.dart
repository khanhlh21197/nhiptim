import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:technonhiptim/helper/loader.dart';
import 'package:technonhiptim/helper/models.dart';
import 'package:technonhiptim/helper/mqttClientWrapper.dart';
import 'package:technonhiptim/helper/shared_prefs_helper.dart';
import 'package:technonhiptim/model/thietbi.dart';

import '../helper/constants.dart' as Constants;

class AddDeviceScreen extends StatefulWidget {
  final List<String> dropDownItems;

  const AddDeviceScreen({Key key, this.dropDownItems}) : super(key: key);

  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  MQTTClientWrapper mqttClientWrapper;
  SharedPrefsHelper sharedPrefsHelper;

  final scrollController = ScrollController();
  final vitriController = TextEditingController();
  final idController = TextEditingController();
  String iduser = "";

  @override
  void initState() {
    initMqtt();
    getSharedPref();
    super.initState();
  }

  Future<void> getSharedPref() async {
    sharedPrefsHelper = SharedPrefsHelper();
    iduser = await sharedPrefsHelper.getStringValuesSF('iduser');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thêm người',
        ),
        centerTitle: true,
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        child: Scrollbar(
          isAlwaysShown: true,
          controller: scrollController,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                idDeviceContainer(
                  'Mã thiết bị',
                  Icon(Icons.vpn_key),
                  TextInputType.text,
                  idController,
                ),
                buildTextField(
                  'Vị trí',
                  Icon(Icons.email),
                  TextInputType.text,
                  vitriController,
                ),
                buildButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget idDeviceContainer(String labelText, Icon prefixIcon,
      TextInputType keyboardType, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 44,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        autocorrect: false,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: labelText,
          // labelStyle: ,
          // hintStyle: ,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 20,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.qr_code),
            onPressed: () async {
              String cameraScanResult = await scanner.scan();
              controller.text = cameraScanResult;
            },
          ),
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, Icon prefixIcon,
      TextInputType keyboardType, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 44,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        autocorrect: false,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: labelText,
          // labelStyle: ,
          // hintStyle: ,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 20,
          ),
          // suffixIcon: Icon(Icons.account_balance_outlined),
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }

  Widget buildButton() {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 32,
      ),
      child: Row(
        children: [
          Expanded(
            child: FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Hủy'),
            ),
          ),
          Expanded(
            child: RaisedButton(
              onPressed: () {
                tryAdd();
              },
              color: Colors.blue,
              child: Text('Lưu'),
            ),
          ),
        ],
      ),
    );
  }

  void tryAdd() {
    if (idController.text.isEmpty) {
      Dialogs.showAlertDialog(context, 'Vui lòng nhập đủ thông tin!');
      return;
    }
    ThietBi tb = ThietBi(
      iduser,
      idController.text,
      vitriController.text,
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
    publishMessage('registertb', jsonEncode(tb));
  }

  void showLoadingDialog() {
    Dialogs.showLoadingDialog(context, _keyLoader);
  }

  void hideLoadingDialog() {
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
  }

  Future<void> initMqtt() async {
    mqttClientWrapper =
        MQTTClientWrapper(() => print('Success'), (message) => handle(message));
    await mqttClientWrapper.prepareMqttClient(Constants.mac);
  }

  void handle(String message) {
    Map responseMap = jsonDecode(message);
    if (responseMap['result'] == 'true' && responseMap['errorCode'] == '0') {
      Navigator.pop(context);
    }
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
  void dispose() {
    scrollController.dispose();
    vitriController.dispose();
    idController.dispose();
    super.dispose();
  }
}
