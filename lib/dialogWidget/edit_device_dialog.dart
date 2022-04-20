import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:technonhiptim/helper/models.dart';
import 'package:technonhiptim/helper/mqttClientWrapper.dart';
import 'package:technonhiptim/helper/shared_prefs_helper.dart';
import 'package:technonhiptim/model/thietbi.dart';

import '../helper/constants.dart' as Constants;

class EditDeviceDialog extends StatefulWidget {
  final ThietBi thietbi;
  final List<String> dropDownItems;
  final Function(dynamic) updateCallback;
  final Function(dynamic) deleteCallback;

  const EditDeviceDialog(
      {Key key,
      this.thietbi,
      this.dropDownItems,
      this.updateCallback,
      this.deleteCallback})
      : super(key: key);

  @override
  _EditDeviceDialogState createState() => _EditDeviceDialogState();
}

class _EditDeviceDialogState extends State<EditDeviceDialog> {
  static const UPDATE_DEVICE = 'updatetb';
  static const DELETE_DEVICE = 'deletetb';
  ThietBi updatedDevice;

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final scrollController = ScrollController();
  final idController = TextEditingController();
  final vitriController = TextEditingController();

  MQTTClientWrapper mqttClientWrapper;
  SharedPrefsHelper sharedPrefsHelper;
  String pubTopic = '';
  String currentSelectedValue;
  ThietBi updatloedDevice;
  String iduser;

  @override
  void initState() {
    initMqtt();
    getSharedPref();
    initController();
    super.initState();
  }

  Future<void> getSharedPref() async {
    sharedPrefsHelper = SharedPrefsHelper();
    iduser = await sharedPrefsHelper.getStringValuesSF('iduser');
  }

  Future<void> initMqtt() async {
    mqttClientWrapper =
        MQTTClientWrapper(() => print('Success'), (message) => handle(message));
    await mqttClientWrapper.prepareMqttClient(Constants.mac);
  }

  void handle(String message) {
    Map responseMap = jsonDecode(message);
    if (responseMap['result'] == 'true' && responseMap['errorCode'] == '0') {
      switch (pubTopic) {
        case UPDATE_DEVICE:
          widget.updateCallback(updatedDevice);
          break;
        case DELETE_DEVICE:
          widget.deleteCallback('true');
          Navigator.of(context).pop();
      }
      Navigator.of(context).pop();
    }
  }

  void initController() async {
    idController.text = widget.thietbi.mathietbi;
    vitriController.text = widget.thietbi.vitri;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
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
                buildTextField(
                  'Mã bệnh nhân',
                  Icon(Icons.vpn_key),
                  TextInputType.visiblePassword,
                  idController,
                ),
                buildTextField(
                  'Họ và tên',
                  Icon(Icons.vpn_key),
                  TextInputType.text,
                  vitriController,
                ),
                deleteButton(),
                buildButton(),
              ],
            ),
          ),
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
                'Xóa người ?',
              ),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () => {
                    Navigator.of(context).pop(),
                  },
                  child: new Text(
                    'Hủy',
                  ),
                ),
                new FlatButton(
                  onPressed: () {
                    pubTopic = DELETE_DEVICE;
                    var d = ThietBi(
                      iduser,
                      widget.thietbi.mathietbi,
                      widget.thietbi.vitri,
                      widget.thietbi.soloi,
                      widget.thietbi.dienap,
                      widget.thietbi.trangthai,
                      widget.thietbi.TDS,
                      widget.thietbi.Loi1,
                      widget.thietbi.Loi2,
                      widget.thietbi.Loi3,
                      widget.thietbi.Loi4,
                      widget.thietbi.Loi5,
                      widget.thietbi.Loi6,
                      widget.thietbi.Loi7,
                      widget.thietbi.Loi8,
                      widget.thietbi.Loi9,
                      widget.thietbi.Loi10,
                      widget.thietbi.Loi11,
                      widget.thietbi.Loi12,
                      widget.thietbi.ngaykichhoat,
                      widget.thietbi.timeupdate,
                      Constants.mac,
                    );
                    publishMessage(pubTopic, jsonEncode(d));
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
              'Xóa người',
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
          ],
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
                widget.updateCallback('abc');
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
          ),
          Expanded(
            child: RaisedButton(
              onPressed: () {
                _tryEdit();
              },
              color: Colors.blue,
              child: Text('Lưu'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _tryEdit() async {
    updatedDevice = ThietBi(
      iduser,
      widget.thietbi.mathietbi,
      widget.thietbi.vitri,
      widget.thietbi.soloi,
      widget.thietbi.dienap,
      widget.thietbi.trangthai,
      widget.thietbi.TDS,
      widget.thietbi.Loi1,
      widget.thietbi.Loi2,
      widget.thietbi.Loi3,
      widget.thietbi.Loi4,
      widget.thietbi.Loi5,
      widget.thietbi.Loi6,
      widget.thietbi.Loi7,
      widget.thietbi.Loi8,
      widget.thietbi.Loi9,
      widget.thietbi.Loi10,
      widget.thietbi.Loi11,
      widget.thietbi.Loi12,
      widget.thietbi.ngaykichhoat,
      widget.thietbi.timeupdate,
      Constants.mac,
    );
    pubTopic = UPDATE_DEVICE;
    publishMessage(pubTopic, jsonEncode(updatedDevice));
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
    idController.dispose();
    vitriController.dispose();
    super.dispose();
  }
}
