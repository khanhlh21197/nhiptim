
import 'dart:ui';

final double defaultZoom = 10.8746;
final double newZoom = 15.8746;

//type of add
const int ADD_DEPARTMENT = 0;
const int ADD_ROOM = 1;
const int ADD_DEVICE = 2;

const int EDIT_HOME = 0;
const int EDIT_ROOM = 1;
const int EDIT_DEVICE = 2;

final String defaultMarkerId = "1";

const Color PRIMARY_COLOR = Color(0xff222831);
const Color BACKGROUND_COLOR = Color(0xffeeeeee);
const Color FOREGROUND_COLOR = Color(0xffC94D49);
const Color PRICE_COLOR_PRIMARY = FOREGROUND_COLOR;
const Color PRICE_COLOR_ON_FORE = Color(0xfffbd46d);
const Color PRIMARY_TEXT_COLOR = PRIMARY_COLOR;
const Color FORE_TEXT_COLOR = BACKGROUND_COLOR;

//////FOOD
//const Color PRIMARY_COLOR = Color(0xff000000);
//const Color BACKGROUND_COLOR = Color(0xffF7EBE8);
//const Color FOREGROUND_COLOR = Color(0xffFACC6B);
//const Color PRICE_COLOR_PRIMARY = Colors.red;
//const Color PRICE_COLOR_ON_FORE = Colors.red;
//const Color PRIMARY_TEXT_COLOR = PRIMARY_COLOR;
//const Color FORE_TEXT_COLOR = BACKGROUND_COLOR;

// final String serverUri = "test.mosquitto.org";
// final int port = 1883;
// final String topicName = "Dart/Mqtt_client/testtopic";
final String server_uri_key = 'serverUri';

// final String serverUri = "45.119.82.186";
// final String serverUri = "192.168.1.238";
// final String serverUri = "192.168.137.1";

final String serverUri = "103.237.145.184";

// final String serverUri = "192.168.2.6";
// final int port = 1234;
// final int port = 4567;
//  final int port = 6789;
final int port = 8796;
const GET_DEVICE = 'gettbmatram';
final String login_topic = "loginuser";
final String patient_login_topic = "loginbenhnhan";
final String home_status = "statusnha";

final String room_status = "statusphong";
final String device_status = "statusphong";
// String mac = "02:00:00:00:00:00";
String mac = "";

const one_signal_app_id = 'a1a1e6bc-a6a4-477f-841a-911ad52646ff';

const UPDATE_USER = 'updateuser';
const UPDATE_PARENT = 'updateph';
const DELETE_PARENT = 'deleteph';
const DELETE_USER = 'deleteuser';
const CHANGE_PASSWORD_USER = 'updatepass';
const CHANGE_PASSWORD_PARENT = 'updatepassph';
const GET_INFO_USER = 'getinfouser';
const GET_INFO_PARENT = 'getinfoph';
const kPrimaryColor = Color(0xFF6F35A5);
const kPrimaryLightColor = Color(0xFFF1E6FF);

//OneSignal App ID


// Future<String> getId() async {
//   DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
//   if (Platform.isAndroid) {
//     AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
//     mac = androidDeviceInfo.id;
//     return Future.value(androidDeviceInfo.id);
//   } else if (Platform.isIOS) {
//     IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
//     mac = iosInfo.identifierForVendor;
//     return Future.value(iosInfo.identifierForVendor);
//   }
// }
