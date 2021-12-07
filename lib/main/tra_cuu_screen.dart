import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:technonhiptim/helper/models.dart';
import 'package:technonhiptim/helper/mqttClientWrapper.dart';
import 'package:technonhiptim/helper/shared_prefs_helper.dart';
import 'package:technonhiptim/model/department.dart';
import 'package:technonhiptim/model/nguoidung.dart';
import 'package:technonhiptim/model/thietbi.dart';
import 'package:technonhiptim/model/tracuu.dart';
import 'package:technonhiptim/response/device_response.dart';
import '../helper/constants.dart' as Constants;

class TraCuuScreen extends StatefulWidget {
  const TraCuuScreen({Key key}) : super(key: key);

  @override
  _TraCuuScreenState createState() => _TraCuuScreenState();
}

class _TraCuuScreenState extends State<TraCuuScreen> {
  static const GET_DEPARTMENT = 'getdiadiem';
  static const GET_BENHNHAN = 'getF0';
  static const GET_TRACUU = 'gettracuu';


  final scrollController = ScrollController();
  String currentSelectedMaDiaDiem;
  String currentSelectedMaBenhNhan;
  String pubTopic;
  String tu = '';
  String den = '';
  DateTime selectedDateTu;
  DateTime selectedDateDen;
  var dropDownItems = ['  '];
  var dropBenhnhan = ['  '];

  MQTTClientWrapper mqttClientWrapper;
  SharedPrefsHelper sharedPrefsHelper;
  List<Department> departments = List();
  List<ThietBi> benhnhans = List();
  List<NguoiDung> peoples = List();


  bool isLoading = false;

  @override
  void initState() {
    selectedDateTu = DateTime.now();
    selectedDateDen = DateTime.now();
    // TODO: implement initState
    initMqtt();
    super.initState();
  }

  Future<void> initMqtt() async {
    mqttClientWrapper =
        MQTTClientWrapper(() => print('Success'), (message) => handle(message));
    await mqttClientWrapper.prepareMqttClient(Constants.mac);
    getDepartment();

    Future.delayed(Duration(seconds: 1), () {
      getDevices();
    });
  }

  void getDevices() async {
    ThietBi t = ThietBi(
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      Constants.mac,
    );
    pubTopic = GET_BENHNHAN;
    publishMessage(pubTopic, jsonEncode(t));
    showLoadingDialog();
  }

  void getDepartment() async {
    Department d = Department('', '', '', Constants.mac);
    pubTopic = GET_DEPARTMENT;
    publishMessage(pubTopic, jsonEncode(d));
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

  void handle(String message) {
    Map responseMap = jsonDecode(message);
    var response = DeviceResponse.fromJson(responseMap);
    switch (pubTopic) {
      case GET_DEPARTMENT:
        departments = response.id.map((e) => Department.fromJson(e)).toList();
        dropDownItems.clear();
        departments.forEach((element) {
          dropDownItems.add(element.madiadiem);
        });
        hideLoadingDialog();
        print('_AddScreenState.handle dia diem ${dropDownItems.length}');
        break;
      case GET_BENHNHAN:
        benhnhans = response.id.map((e) => ThietBi.fromJson(e)).toList();
        dropBenhnhan.clear();
        benhnhans.forEach((element) {
          dropBenhnhan.add(element.magiamsat);
        });
        hideLoadingDialog();
        print('_AddScreenState.handle nguoi ${dropBenhnhan.length}');

        break;
      case GET_TRACUU:
          peoples = response.id.map((e) => NguoiDung.fromJson(e)).toList();
          setState(() {});
          peoples.forEach((element) {
            if (double.tryParse(element.nhietdo) > 37.5) {
              element.color = Colors.red;
              setState(() {

              });
            }
            if (double.tryParse(element.nhiptim) > 100) {
              element.color1 = Colors.red;
              setState(() {

              });
            }
            if (double.tryParse(element.nongdooxy) < 95) {
              element.color2 = Colors.red;
              setState(() {

              });
            }
          });
          hideLoadingDialog();
          break;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Tìm kiếm'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
        children: [
          Container(
            child: Column(
              children: [
                buildDepartment('Mã phòng *'),
                SizedBox(height: 5,),
                buildBenhNhan('Mã bệnh nhân *'),
                SizedBox(height: 5,),
                buildTextDateTu('Từ ngày'),
                SizedBox(height: 5,),
                buildTextDateDen('Đến ngày'),
              ],
            ),
          ),
          buildButton(),
          buildBodyTraCuu(),

        ],
    ),
      ),
    );
  }

  Widget buildBodyTraCuu() {
    return SingleChildScrollView(
      child: Container(
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
      ),
    );
  }

  Widget buildTableTitle() {
    return SingleChildScrollView(
      child: Container(
        height: 40,
        child: Row(
          children: [
            SizedBox(
              width: 1,
            ),
            verticalLine(),
            buildTextLabel('Họ và tên', 3),
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
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: peoples.length,
        itemBuilder: (context, index) {
          return itemView(index);
        },
      ),
    );
  }

  Widget itemView(int index) {
    return SingleChildScrollView(
      child: InkWell(
        onTap: () async {},
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: SingleChildScrollView(
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
                            peoples[index].hoten,
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
                            peoples[index].magiamsat,
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
          ),
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

  Widget buildButton() {
    return RaisedButton(
      color: Colors.greenAccent,
      onPressed: () {
        TraCuu tc = TraCuu(
          currentSelectedMaDiaDiem ?? '',
          currentSelectedMaBenhNhan ?? '',
          // selectedDateTu.toString().split(' ')[0] ?? '',
          tu,
          // selectedDateDen.toString().split(' ')[0] ?? '',
          den,
          Constants.mac,
        );
        pubTopic = GET_TRACUU;
        publishMessage(pubTopic, jsonEncode(tc));
        // navigatorPush(
        //     context, KetQuaTraCuuScreen(),);
      },
      child: Text('Tìm kiếm', style: TextStyle(fontSize: 16)),
    );
  }

  Widget buildTextDateTu(String textTime) {
    return Container(
      height: 40,
      // margin: const EdgeInsets.symmetric(
      //   horizontal: 32,
      //   vertical: 8,
      // ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              textTime,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: datePickerTu(),
          ),
        ],
      ),
    );
  }

  Widget buildTextDateDen(String textTime) {
    return Container(
      height: 40,
      // margin: const EdgeInsets.symmetric(
      //   horizontal: 32,
      //   vertical: 8,
      // ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              textTime,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: datePickerDen(),
          ),
        ],
      ),
    );
  }

  Widget datePickerTu() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              tu,
              // "${selectedDateTu.toString()}".split(' ')[0],
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 1,
          ),
          Expanded(
            child: RaisedButton(
              onPressed: () => _selectDateTu(context),
              child: Text(
                'Chọn ngày',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              color: Colors.greenAccent,
            ),
          ),
        ],
      ),
    );
  }

  Future _selectDateTu(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDateTu,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDateTu)
      setState(() {
        selectedDateTu = picked;
        tu = DateFormat('yyyy-MM-dd').format(selectedDateTu);
      });
  }

  Widget datePickerDen() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              den,
              // "${selectedDateDen.toString()}".split(' ')[0],
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 1,
          ),
          Expanded(
            child: RaisedButton(
              onPressed: () => _selectDateDen(context),
              child: Text(
                'Chọn ngày',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              color: Colors.greenAccent,
            ),
          ),
        ],
      ),
    );
  }

  Future _selectDateDen(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDateTu,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDateDen)
      setState(() {
        selectedDateDen = picked;
        den = DateFormat('yyyy-MM-dd').format(selectedDateDen);

      });
  }

  Widget buildDepartment(String label) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          5,
        ),
        border: Border.all(
          color: Colors.green,
        ),
      ),
      // margin: const EdgeInsets.symmetric(
      //   horizontal: 32,
      //   vertical: 8,
      // ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            width: 70,
          ),
          dropdownDepartment(),
        ],
      ),
    );
  }

  Widget dropdownDepartment() {
    return Container(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text("Chọn phòng"),
          value: currentSelectedMaDiaDiem,
          isDense: true,
          onChanged: (newValue) {
            setState(() {
              currentSelectedMaDiaDiem = newValue;
            });
            print(currentSelectedMaDiaDiem);
          },
          items: dropDownItems.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget buildBenhNhan(String label) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          5,
        ),
        border: Border.all(
          color: Colors.green,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            width: 40,
          ),
          dropdownBenhNhan(),
        ],
      ),
    );
  }

  Widget dropdownBenhNhan() {
    return Container(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text("Chọn bệnh nhân "),
          value: currentSelectedMaBenhNhan,
          isDense: true,
          onChanged: (newValue) {
            setState(() {
              currentSelectedMaBenhNhan = newValue;
            });
            print(currentSelectedMaBenhNhan);
          },
          items: dropBenhnhan.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }
}
