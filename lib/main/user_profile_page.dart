
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:technonhiptim/dialogWidget/edit_user_dialog.dart';
import 'package:technonhiptim/helper/constants.dart' as Constants;
import 'package:technonhiptim/helper/models.dart';
import 'package:technonhiptim/helper/mqttClientWrapper.dart';
import 'package:technonhiptim/helper/shared_prefs_helper.dart';
import 'package:technonhiptim/login/login_page.dart';
import 'package:technonhiptim/model/department.dart';
import 'package:technonhiptim/model/user.dart';
import 'package:technonhiptim/navigator.dart';
import 'package:technonhiptim/response/device_response.dart';

class UserProfilePage extends StatefulWidget {
  final bool switchValue;

  const UserProfilePage({Key key, this.switchValue}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  MQTTClientWrapper mqttClientWrapper;
  SharedPrefsHelper sharedPrefsHelper;
  User user;
  String pubTopic = '';
  List<Department> departments = List();
  var dropDownItems = [''];

  bool isLoading = true;

  @override
  void initState() {
    sharedPrefsHelper = SharedPrefsHelper();
    user = User(
      '',
      'Tên đăng nhập',
      'Mật khẩu',
      'Tên',
      'SĐT',
      'Địa chỉ',
      'Khoa',
      'Quyền',
      '',
    );
    initMqtt();
    super.initState();
  }

  Future<void> initMqtt() async {
    mqttClientWrapper =
        MQTTClientWrapper(() => print('Success'), (message) => handle(message));
    await mqttClientWrapper.prepareMqttClient(Constants.mac);
    getInfoUser();
  }

  void getInfoUser() async {
    if (widget.switchValue) {
      pubTopic = Constants.GET_INFO_PARENT;
    } else {
      pubTopic = Constants.GET_INFO_USER;
    }
    String email = await sharedPrefsHelper.getStringValuesSF('email');
    String password = await sharedPrefsHelper.getStringValuesSF('password');
    if (email.isNotEmpty && password.isNotEmpty) {
      User user = User(
        Constants.mac,
        email,
        password,
        '',
        '',
        '',
        '',
        '',
        '',
      );
      publishMessage(pubTopic, jsonEncode(user));
    }
    showLoadingDialog();
  }


  Widget _placeContainer(String title, Color color, Widget icon) {
    if (title.length > 20) {
      title = title.substring(0, 20) + '...';
    }
    return Column(
      children: <Widget>[
        Container(
            height: 50,
            width: MediaQuery.of(context).size.width - 40,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: color),
            child: Row(
              children: <Widget>[
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                icon ?? Spacer(),
              ],
            ))
      ],
    );
  }

  Widget _editContainer(String title, Color color, Widget icon) {
    return InkWell(
      onTap: () async {
        // getDepartment();
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                //this right here
                child: Container(
                  child: EditUserDialog(
                    user: user,
                    deleteCallback: (param) {
                      getInfoUser();
                    },
                    updateCallback: (updatedDevice) {
                      getInfoUser();
                    },
                    switchValue: widget.switchValue,
                  ),
                ),
              );
            });
      },
      child: Column(
        children: <Widget>[
          Container(
              height: 50,
              width: MediaQuery.of(context).size.width - 40,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: color),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  icon != null ? icon : Spacer(),
                ],
              ))
        ],
      ),
    );
  }

  Widget _logoutContainer(String title, Color color, Widget icon) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text('Bạn muốn đăng xuất ?'),
                // content: new Text('Bạn muốn thoát ứng dụng?'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('Hủy'),
                  ),
                  new FlatButton(
                    onPressed: () {
                      setState(() {
                        navigatorPushAndRemoveUntil(context, LoginPage());
                      });
                    },
                    child: new Text('Đồng ý'),
                  ),
                ],
              );
            });
      },
      child: Column(
        children: <Widget>[
          Container(
              height: 50,
              width: MediaQuery.of(context).size.width - 40,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: color),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  icon != null ? icon : Spacer(),
                ],
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Tài khoản'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
        color: Color(0xffe7eaf2),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(40.0, 40, 40, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                user.tenDecode.isEmpty
                    ? Container()
                    : CircleAvatar(
                    backgroundColor: Colors.brown.shade800,
                    minRadius: 40,
                    child: Text(
                      user.tenDecode[0].toUpperCase(),
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 15,
                ),
                _placeContainer(
                    user.tenDecode != null
                        ? 'Tên: ${user.tenDecode}'
                        : 'Chưa nhập tên',
                    Colors.white,
                    null),
                _placeContainer(
                    'Tên ĐN: ${user.user ?? ''}', Colors.white, null),
                _placeContainer(
                    user.nhaDecode != null
                        ? 'Địa chỉ: ${user.nhaDecode}'
                        : 'Chưa nhập địa chỉ',
                    Colors.white,
                    null),
                _placeContainer(
                    user.sdt != null
                        ? 'SĐT: ${user.sdt}'
                        : 'Chưa nhập SĐT',
                    Colors.white,
                    null),
                _editContainer(
                    'Sửa thông tin', Color(0xffffffff), Icon(Icons.edit)),
                _logoutContainer(
                  'Đăng xuất',
                  Color(0xffffffff),
                  Icon(
                    Icons.power_settings_new,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  handle(String message) async {
    DeviceResponse response = DeviceResponse.fromJson(jsonDecode(message));

    print('Response: ${response.id}');

    switch (pubTopic) {
      case Constants.GET_INFO_USER:
      case Constants.GET_INFO_PARENT:
        setState(() {
          List<User> users = response.id.map((e) => User.fromJson(e)).toList();
          user = users[0];
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
  }

  void hideLoadingDialog() {
    setState(() {
      isLoading = false;
    });
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
