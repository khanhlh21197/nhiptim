import 'package:flutter/cupertino.dart';

class Camera {
  String mathietbi;
  String maphong;
  String mabenhnhan;
  String mac;
  Color color;
  List<dynamic> id;

  Camera(this.mathietbi, this.maphong, this.mabenhnhan, this.mac);

  Camera.fromJson(Map<String, dynamic> json)
      : mathietbi = json['mathietbi'],
        maphong = json['maphong'],
        mabenhnhan = json['mabenhnhan'],
        mac = json['mac'];

  Map<String, dynamic> toJson() => {
    'mathietbi': mathietbi,
    'maphong': maphong,
    'mabenhnhan': mabenhnhan,
    'mac': mac,
  };

  @override
  String toString() {
    return '$mathietbi - $maphong - $mabenhnhan';
  }
}
