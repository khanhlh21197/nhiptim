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
  static const UPDATE_DEVICE = 'updateF0';
  static const DELETE_DEVICE = 'deleteF0';

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  final scrollController = ScrollController();
  final idController = TextEditingController();
  final nameController = TextEditingController();
  final gioitinhController = TextEditingController();
  final ngaysinhController = TextEditingController();
  final sodienthoaiController = TextEditingController();
  final diachiController = TextEditingController();
  final giosangController = TextEditingController();
  final giochieuController = TextEditingController();

  MQTTClientWrapper mqttClientWrapper;
  SharedPrefsHelper sharedPrefsHelper;
  String pubTopic = '';
  String currentSelectedValue;
  ThietBi updatloedDevice;

  @override
  void initState() {
    initMqtt();
    initController();
    super.initState();
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
    idController.text = widget.thietbi.mabenhnhan;
    currentSelectedValue = widget.thietbi.maphong;
    nameController.text = widget.thietbi.hoten;
    gioitinhController.text = widget.thietbi.gioitinh;
    sodienthoaiController.text = widget.thietbi.sodienthoai;
    diachiController.text = widget.thietbi.diachi;
    ngaysinhController.text = widget.thietbi.ngaysinh;
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
                  nameController,
                ),
                buildTextField(
                  'Giới tính',
                  Icon(Icons.vpn_key),
                  TextInputType.text,
                  gioitinhController,
                ),
                buildTextField(
                  'Ngày sinh',
                  Icon(Icons.vpn_key),
                  TextInputType.datetime,
                  ngaysinhController,
                ),
                buildTextField(
                  'Số điện thoại',
                  Icon(Icons.vpn_key),
                  TextInputType.number,
                  sodienthoaiController,
                ),
                buildTextField(
                  'Địa chỉ',
                  Icon(Icons.vpn_key),
                  TextInputType.text,
                  diachiController
                ),
                // buildTextField(
                //   'Giờ sáng',
                //   Icon(Icons.vpn_key),
                //   TextInputType.text,
                //   giosangController
                // ),
                // buildTextField(
                //   'Giờ chiều',
                //   Icon(Icons.vpn_key),
                //   TextInputType.text,
                //   giochieuController
                // ),
                buildTextField(
                  'Giới tính',
                  Icon(Icons.vpn_key),
                  TextInputType.text,
                  gioitinhController,
                ),
                buildDepartment(),
                deleteButton(),
                buildButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDepartment() {
    return Container(
      height: 44,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          5,
        ),
        border: Border.all(
          color: Colors.green,
        ),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 32,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              'Mã phòng',
            ),
          ),
          Expanded(
            child: dropdownDepartment(),
          ),
        ],
      ),
    );
  }

  Widget dropdownDepartment() {
    return Container(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text("Chọn phòng"),
          value: currentSelectedValue,
          isDense: true,
          onChanged: (newValue) {
            setState(() {
              currentSelectedValue = newValue;
            });
            print(currentSelectedValue);
          },
          items: widget.dropDownItems.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
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
                      widget.thietbi.mabenhnhan,
                      widget.thietbi.maphong,
                      widget.thietbi.hoten,
                      widget.thietbi.gioitinh,
                      widget.thietbi.ngaysinh,
                      widget.thietbi.sodienthoai,
                      widget.thietbi.diachi,
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
      idController.text,
      currentSelectedValue,
      nameController.text,
      gioitinhController.text,
      ngaysinhController.text,
      sodienthoaiController.text,
      diachiController.text,
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
    nameController.dispose();
    gioitinhController.dispose();
    ngaysinhController.dispose();
    sodienthoaiController.dispose();
    diachiController.dispose();
    giosangController.dispose();
    giochieuController.dispose();
    super.dispose();
  }
}
