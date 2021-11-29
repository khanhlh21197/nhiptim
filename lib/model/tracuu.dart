import 'package:flutter/cupertino.dart';

class TraCuu {
  String madiadiem;
  String magiamsat;
  String tungay;
  String denngay;
  String mac;
  Color color;
  Color color1;
  Color color2;
  List<dynamic> id;

  TraCuu( this.madiadiem, this.magiamsat, this.tungay, this.denngay, this.mac);

  TraCuu.fromJson(Map<String, dynamic> json)
      : madiadiem = json['madiadiem'],
        magiamsat = json['magiamsat'],
        tungay = json['tungay'],
        denngay = json['denngay'],
        mac = json['mac'];

  Map<String, dynamic> toJson() => {
    'madiadiem': madiadiem,
    'magiamsat': magiamsat,
    'tungay': tungay,
    'denngay': denngay,
    'mac': mac,
  };

  @override
  String toString() {
    return '$madiadiem -$magiamsat -$tungay - $denngay';
  }
}
