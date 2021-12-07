import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:technonhiptim/Widget/bezierContainer.dart';
import 'package:technonhiptim/helper/constants.dart';
import 'package:technonhiptim/helper/loader.dart';
import 'package:technonhiptim/helper/models.dart';
import 'package:technonhiptim/helper/shared_prefs_helper.dart';
import 'package:technonhiptim/main/benh_nhan.dart';
import 'package:technonhiptim/main/giamsat.dart';
import 'package:technonhiptim/main/home_screen.dart';
import 'package:technonhiptim/model/user.dart';
import 'package:technonhiptim/navigator.dart';
import 'package:technonhiptim/response/device_response.dart';
import 'package:technonhiptim/singup/signup.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../helper/constants.dart' as Constants;
import '../helper/mqttClientWrapper.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title, this.registerUser}) : super(key: key);

  final String title;
  final User registerUser;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  MQTTClientWrapper mqttClientWrapper;
  SharedPrefsHelper sharedPrefsHelper;
  bool loading = false;
  bool _switchValue = false;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  String iduser;
  var status;
  String playerid = '';
  bool switchValue = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initMqtt();
    initOneSignal(Constants.one_signal_app_id);
    sharedPrefsHelper = SharedPrefsHelper();
    getSharedPrefs();
  }

  void initOneSignal(oneSignalAppId) async {
    var settings = {
      OSiOSSettings.autoPrompt: true,
      OSiOSSettings.inAppLaunchUrl: true
    };
    OneSignal.shared.init(
      one_signal_app_id,
      iOSSettings: settings,
    );

    status = await OneSignal.shared.getPermissionSubscriptionState();

    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
// will be called whenever a notification is received
    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
      print('Received: ' + notification?.payload?.body ?? '');
    });
// will be called whenever a notification is opened/button pressed.
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print('Opened: ' + result.notification?.payload?.body ?? '');
    });
  }

  Future<void> initMqtt() async {
    mqttClientWrapper =
        MQTTClientWrapper(() => print('Success'), (message) => login(message));
    await mqttClientWrapper.prepareMqttClient(Constants.mac);
    print('_LoginPageState.initMqtt MAC: ${Constants.mac}');
  }

  Future<void> getSharedPrefs() async {
    // await sharedPrefsHelper.addBoolToSF('switchValue', true);
    _emailController.text = await sharedPrefsHelper.getStringValuesSF('email');
    _passwordController.text =
    await sharedPrefsHelper.getStringValuesSF('password');
    _switchValue = await sharedPrefsHelper.getBoolValuesSF('switchValue');
    print('_LoginPageState.getSharedPrefs $_switchValue');
    print('_LoginPageState.getSharedPrefs ${_emailController.text}');

    // if (_emailController.text.isNotEmpty &&
    //     _passwordController.text.isNotEmpty) {
    //   await _tryLogin();
    // }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void>  _tryLogin() async {
    setState(() {
      loading = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (loading) {
        hideLoadingDialog();
        _showToast(context);
      }
    });
    try {
      playerid = await status.subscriptionStatus.userId;
    } catch (e) {
      print('_LoginPageState._tryLogin error: ${e.toString()}');
    }
    print('_LoginPageState.initOneSignal playerID: $playerid');
    User user = User(Constants.mac, _emailController.text,
        _passwordController.text, '', '', '', '', '', playerid);
    await initMqtt();
    mqttClientWrapper.login(user);
    // if (mqttClientWrapper.connectionState ==
    //     MqttCurrentConnectionState.CONNECTED) {
    //   if (switchValue) {
    //     mqttClientWrapper.login(user);
    //   } else {
    //     mqttClientWrapper.login(user);
    //   }
    // } else {
    //   await initMqtt();
    //   if (switchValue) {
    //     mqttClientWrapper.login(user);
    //   } else {
    //     mqttClientWrapper.login(user);
    //   }
    // }
  }

  Future<void> login(String message) async {
    hideLoadingDialog();
    print('_LoginPageState.login $message');
    Map responseMap = jsonDecode(message);

    iduser = DeviceResponse.fromJson(responseMap).message;
    await sharedPrefsHelper.addStringToSF('iduser', iduser);

    if (responseMap['result'] == 'true') {
      setState(() {
        loading = false;
      });
      print('Login success');
      // if (_switchValue != null) {
      //   if (_switchValue) {
      //     await sharedPrefsHelper.addStringToSF('email', _emailController.text);
      //     await sharedPrefsHelper.addStringToSF(
      //         'password', _passwordController.text);
      //     await sharedPrefsHelper.addBoolToSF('switchValue', _switchValue);
      //   } else {
      //     await sharedPrefsHelper.removeValues();
      //   }
      // }
      await sharedPrefsHelper.addStringToSF('email', _emailController.text);
      await sharedPrefsHelper.addStringToSF(
          'password', _passwordController.text);
      await sharedPrefsHelper.addBoolToSF('switchValue', _switchValue);
      await sharedPrefsHelper.addBoolToSF('login', true);
      // navigatorPushAndRemoveUntil(
      //   context,
      //   HomeScreen(
      //     loginResponse: responseMap,
      //   ),
      // );
      if (_emailController.text == 'admin' && switchValue == false) {
        navigatorPushAndRemoveUntil(context,HomeScreen(
          loginResponse: responseMap,
        ) );
      }
      if (_emailController.text != 'admin' && switchValue == true){
        navigatorPushAndRemoveUntil(context,BenhNhan());
      }
      // if (switchValue) {
      //   navigatorPushAndRemoveUntil(context,BenhNhan());
      // } else {
      //   navigatorPushAndRemoveUntil(context,HomeScreen(
      //     loginResponse: responseMap,
      //   ) );
      // }
    } else {
      this._showToast(context);
    }
  }

  void _showToast(BuildContext context) {
    Dialogs.showAlertDialog(
        context, 'Đăng nhập thất bại, vui lòng thử lại sau!');
  }

  Widget _entryField(String title, TextEditingController _controller,
      {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              controller: _controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  void showLoadingDialog() {
    Dialogs.showLoadingDialog(context, _keyLoader);
  }

  void hideLoadingDialog() {
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        showLoadingDialog();
        await _tryLogin();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.lightBlueAccent, Colors.blueAccent])),
        child: Text(
          'Đăng nhập',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _facebookButton() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff2872ba),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/techno_me.png'),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'TechNo M&E',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Chưa có tài khoản ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Đăng ký',
              style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.add_circle_outline,
          size: 40,
          color: Colors.red,
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: 'H',
              style: GoogleFonts.portLligatSans(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Colors.blueAccent,
              ),
              children: const [
                TextSpan(
                  text: 'ealth',
                  style: TextStyle(color: Colors.black, fontSize: 30),
                ),
                TextSpan(
                  text: 'Care',
                  style: TextStyle(color: Colors.blueAccent, fontSize: 30),
                ),
              ]),
        ),
      ],
    );
  }


  Widget _header() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
      ),
      child: Container(
        height: 100,
        width: 100,
        child: Image.asset(
          "assets/images/ic_flame_warning.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Tên đăng nhập", _emailController),
        _entryField("Mật khẩu", _passwordController, isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          height: height,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: BezierContainer(),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      _title(),
                      // _header(),
                      SizedBox(height: 50),
                      _emailPasswordWidget(),
                      _submitButton(),
                      switchContainer(),
                      _divider(),
                      // _facebookButton(),
                      switchValue ? Container() : _createAccountLabel(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget switchContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Y tá',
          ),
          CupertinoSwitch(
            activeColor: Colors.blue,
            value: switchValue ?? false,
            onChanged: (value) {
              setState(() {
                switchValue = value;
                print('_LoginPageState.switchContainer $switchValue');
              });
            },
          ),
          Text(
            'Bệnh nhân',
          ),
        ],
      ),
    );
  }

}

