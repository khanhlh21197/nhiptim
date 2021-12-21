import 'package:flutter/cupertino.dart';

class TraCuu {
  String maphong;
  String mabenhnhan;
  String tungay;
  String denngay;
  String mac;
  Color color;
  Color color1;
  Color color2;
  List<dynamic> id;

  TraCuu( this.maphong, this.mabenhnhan, this.tungay, this.denngay, this.mac);

  TraCuu.fromJson(Map<String, dynamic> json)
      : maphong = json['maphong'],
        mabenhnhan = json['mabenhnhan'],
        tungay = json['tungay'],
        denngay = json['denngay'],
        mac = json['mac'];

  Map<String, dynamic> toJson() => {
    'maphong': maphong,
    'mabenhnhan': mabenhnhan,
    'tungay': tungay,
    'denngay': denngay,
    'mac': mac,
  };

  @override
  String toString() {
    return '$maphong -$mabenhnhan -$tungay - $denngay';
  }
}
