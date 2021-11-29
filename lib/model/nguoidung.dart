import 'package:flutter/cupertino.dart';

class NguoiDung {
  String madiadiem;
  String magiamsat;
  String hoten;
  String gioitinh;
  String ngaysinh;
  String nhietdo;
  String nhiptim;
  String nongdooxy;
  String mac;
  Color color;
  Color color1;
  Color color2;
  List<dynamic> id;

  NguoiDung( this.madiadiem, this.magiamsat, this.hoten, this.gioitinh, this.ngaysinh,
      this.nhietdo, this.nhiptim, this.nongdooxy, this.mac);

  NguoiDung.fromJson(Map<String, dynamic> json)
      : madiadiem = json['madiadiem'],
        magiamsat = json['magiamsat'],
        hoten = json['hoten'],
        gioitinh = json['gioitinh'],
        ngaysinh = json['ngaysinh'],
        nhietdo = json['nhietdo'],
        nhiptim = json['nhiptim'],
        nongdooxy = json['nongdooxy'],
        mac = json['mac'];

  Map<String, dynamic> toJson() => {
    'madiadiem': madiadiem,
    'magiamsat': magiamsat,
    'hoten': hoten,
    'gioitinh': gioitinh,
    'ngaysinh': ngaysinh,
    'nhietdo': nhietdo,
    'nhiptim': nhiptim,
    'nongdooxy': nongdooxy,
    'mac': mac,
  };

  @override
  String toString() {
    return '$madiadiem -$magiamsat -$hoten - $gioitinh - $ngaysinh - $nhietdo -$nhiptim - $nongdooxy';
  }
}
