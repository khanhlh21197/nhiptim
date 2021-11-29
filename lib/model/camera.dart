import 'package:flutter/cupertino.dart';

class Camera {
  String macam;
  String madiadiem;
  String vitri;
  String mac;
  Color color;
  List<dynamic> id;

  Camera(this.macam, this.madiadiem, this.vitri, this.mac);

  Camera.fromJson(Map<String, dynamic> json)
      : macam = json['macam'],
        madiadiem = json['madiadiem'],
        vitri = json['vitri'],
        mac = json['mac'];

  Map<String, dynamic> toJson() => {
    'macam': macam,
    'madiadiem': madiadiem,
    'vitri': vitri,
    'mac': mac,
  };

  @override
  String toString() {
    return '$macam - $madiadiem - $vitri';
  }
}
