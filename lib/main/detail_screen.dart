import 'dart:collection';
import 'dart:convert';

import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/material.dart';
import 'package:technonhiptim/helper/config.dart';
import 'package:technonhiptim/helper/models.dart';
import 'package:technonhiptim/helper/mqttClientWrapper.dart';
import 'package:technonhiptim/helper/shared_prefs_helper.dart';
import 'package:technonhiptim/login/login_page.dart';
import 'package:technonhiptim/model/thietbi.dart';
import 'package:technonhiptim/navigator.dart';
import 'package:technonhiptim/response/device_response.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../helper/constants.dart' as Constants;

class DetailScreen extends StatefulWidget {
  final String matram;

  const DetailScreen({Key key, this.matram}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  MQTTClientWrapper mqttClientWrapper;

  final sharedPrefs = SharedPrefsHelper();
  List<ThietBi> tbs = List();
  List<ThietBi> tbs2 = List();
  LinkedHashSet<String> listtu = LinkedHashSet();
  List<String> listtu2 = List();

  String email;
  String pubTopic;
  bool isLoading = true;
  String trangthai;

  var dropDownProducts = [''];
  String _selectedProduct;
  String _selectedDevice;
  var itemColor;

  @override
  void initState() {
    // isLoading = false;
    // tbs.add(ThietBi('TECHNO1', 'h1.32', 'Online', '50', 'thoigian', 'mac', 'Tu1'));
    // tbs.add(ThietBi('TECHNO2', 'h1.32', 'Online', '60', 'thoigian', 'mac', 'Tu2'));

    getSharedPrefs();
    // initMqtt();
    super.initState();
  }

  // void getDevices() async {
  //   ThietBi t = ThietBi('', widget.matram, '', '', '', Constants.mac, '');
  //   pubTopic = Constants.GET_DEVICE;
  //   publishMessage(pubTopic, jsonEncode(t));
  //   showLoadingDialog();
  // }

  // Future<void> publishMessage(String topic, String message) async {
  //   if (mqttClientWrapper.connectionState ==
  //       MqttCurrentConnectionState.CONNECTED) {
  //     mqttClientWrapper.publishMessage(topic, message);
  //   } else {
  //     await initMqtt();
  //     mqttClientWrapper.publishMessage(topic, message);
  //   }
  // }

  void getSharedPrefs() async {
    email = await sharedPrefs.getStringValuesSF('email');
  }

  // Future<void> matchImages() async {
  //   tbs.forEach((element) {
  //     element.nguongcb = sharedPrefs.getStringValuesSF('${element.matb}');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // matchImages();
    return Scaffold(
      appBar: AppBar(
        title: Text('Giám sát'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                navigatorPushAndRemoveUntil(context, LoginPage());
              }),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : buildBody(),
    );
  }

  Widget buildBody() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.85,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return buildItem(tbs[index]);
              },
              itemCount: tbs.length,
            ),
          )
        ],
      ),
    );
  }

  Widget buildBody2() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.85,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return buildItem2(listtu2[index]);
              },
              itemCount: listtu2.length,
            ),
          )
        ],
      ),
    );
  }

  Widget buildItem(ThietBi tb) {
    return GestureDetector(
      onTap: () {
        _selectedDevice = tb.magiamsat;
        // navigatorPush(context, RollingDoor());
        // getProducts();
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey),
          color: Colors.white,
        ),
        child: Column(
          children: [
            // Text(
            //   tb.tu ?? "",
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     color: Colors.black,
            //   ),
            // ),
            Text(
              tb.magiamsat ?? "",
              style: TextStyle(
                // fontWeight: FontWeight.bold,
                color: tb.color ?? Colors.black,
              ),
            ),
            // sleek(tb.nhietdo ?? "0"),
            // Text(
            //   tb.trangthai ?? 'offline',
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     color: Colors.black,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildItem2(String str) {
    return GestureDetector(
      onTap: () {
        // navigatorPush(context, RollingDoor());
        // getProducts();
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Text(str ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: 10),
            buildThietBi(),
            SizedBox(height: 4),
            buildThietBi(),
            SizedBox(height: 4),
            buildThietBi(),
            // Text(
            //   trangthai ?? 'offline',
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     // color: tb.color ?? Colors.black,
            //     color: Colors.black,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildThietBi() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey),
        color: Colors.white,
      ),
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('MN1'),
          SizedBox(
            width: 5,
          ),
          verticalLine(),
          SizedBox(
            width: 5,
          ),
          Text('50'),
          SizedBox(
            width: 5,
          ),
          verticalLine(),
          SizedBox(
            width: 5,
          ),
          Text('offline'),
        ],
      ),
    );
  }

  void showLoadingDialog() {
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration(seconds: 3), hideLoadingDialog);
  }

  void hideLoadingDialog() {
    setState(() {
      isLoading = false;
    });
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

  // Future<void> initMqtt() async {
  //   mqttClientWrapper =
  //       MQTTClientWrapper(() => print('Success'), (message) => handle(message));
  //   await mqttClientWrapper.prepareMqttClient(Constants.mac);
  //
  //   getDevices();
  //
  //   // tbs.forEach((element) {
  //   //   mqttClientWrapper.subscribe(element.matb, (_message){
  //   //     print('_DetailScreenState.initMqtt $_message');
  //   //   });
  //   // });
  //
  //   mqttClientWrapper.subscribe(widget.matram, (_message) {
  //     print('_DetailScreenState.initMqtt $_message');
  //     var result = _message.replaceAll("\"", "").split('&');
  //     tbs.forEach((element) {
  //       String str = result[2];
  //       if (element.matb == result[0])
  //       if (str == '0') {
  //         element.trangthai = 'offline';
  //       } else if (str == '1') {
  //         element.trangthai = 'online';
  //       }
  //     });
  //
  //     tbs.forEach((element) {
  //       print('_DetailScreenState.initMqtt ${element.matb}');
  //       print('_DetailScreenState.initMqtt ${result[0]}');
  //       if (element.matb == result[0]) {
  //         element.nhietdo = result[1];
  //         // element.trangthai = result[2];
  //         if (double.tryParse(element.nhietdo) >
  //             double.tryParse(element.nguongcb)) {
  //           element.color = Colors.red;
  //         } else {
  //           element.color = Colors.black;
  //         }
  //         // changeItemColor(element);
  //         setState(() {});
  //       } else {
  //         print('_DetailScreenState.initMqtt false');
  //       }
  //     });
  //   });
  // }

  void changeItemColor(ThietBi element) {
    Future.delayed(Duration(milliseconds: 500), () {
      element.color = Colors.white;
      setState(() {});
    });
  }

  // void handle(String message) {
  //   try {
  //     Map responseMap = jsonDecode(message);
  //     var response = DeviceResponse.fromJson(responseMap);
  //
  //     switch (pubTopic) {
  //       case Constants.GET_DEVICE:
  //         tbs = response.id.map((e) => ThietBi.fromJson(e)).toList();
  //         tbs.forEach((element) {
  //           listtu.add(element.tu);
  //         });
  //         listtu2 = listtu.toList();
  //         print('_DetailScreenState.handle listtu: $listtu2');
  //         setState(() {});
  //         hideLoadingDialog();
  //         break;
  //     }
  //     pubTopic = '';
  //   } catch (e) {
  //     print('_DetailScreenState.handle $e');
  //   }
  // }

  Widget clayContainer(String nhietdo) {
    double nd = double.tryParse(nhietdo);
    return ClayContainer(
      height: 50,
      width: 50,
      color: primaryColor,
      borderRadius: 10,
      child: Padding(
        padding: EdgeInsets.all(4),
        child: SleekCircularSlider(
          appearance: CircularSliderAppearance(
            customColors: CustomSliderColors(
              progressBarColors: gradientColors,
              hideShadow: true,
              shadowColor: Colors.transparent,
            ),
            infoProperties: InfoProperties(
                mainLabelStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                modifier: (double value) {
                  final roundedValue = nd.ceil().toInt().toString();
                  return '$roundedValue \u2103';
                }),
          ),
        ),
      ),
    );
  }

  Widget sleek(String nhietdo) {
    double nd = double.tryParse(nhietdo);
    if (nd >= 200) nd = 200;
    return Container(
      width: 80,
      height: 80,
      child: SleekCircularSlider(
        appearance: CircularSliderAppearance(
          customColors: CustomSliderColors(
            progressBarColors: gradientColors,
            hideShadow: true,
            shadowColor: Colors.transparent,
          ),
          customWidths: CustomSliderWidths(progressBarWidth: 10),
          infoProperties: InfoProperties(
              mainLabelStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              modifier: (double value) {
                final roundedValue = nd.ceil().toInt().toString();
                return '$roundedValue \u2103';
              }),
        ),
        min: 0,
        max: 200,
        initialValue: nd,
      ),
    );
  }
}

