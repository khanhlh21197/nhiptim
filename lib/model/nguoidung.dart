import 'package:flutter/cupertino.dart';

class NguoiDung {
  String maphong;
  String mabenhnhan;
  String hoten;
  String gioitinh;
  String ngaysinh;
  String nhietdo;
  String nhiptim;
  String nongdooxy;
  String dungdichtruyen;
  String mac;
  Color color;
  Color color1;
  Color color2;
  Color color3;
  List<dynamic> id;

  NguoiDung( this.maphong, this.mabenhnhan, this.hoten, this.gioitinh, this.ngaysinh,
      this.nhietdo, this.nhiptim, this.nongdooxy, this.dungdichtruyen, this.mac);

  NguoiDung.fromJson(Map<String, dynamic> json)
      : maphong = json['maphong'],
        mabenhnhan = json['mabenhnhan'],
        hoten = json['hoten'],
        gioitinh = json['gioitinh'],
        ngaysinh = json['ngaysinh'],
        nhietdo = json['nhietdo'],
        nhiptim = json['nhiptim'],
        nongdooxy = json['nongdooxy'],
        dungdichtruyen = json['dungdichtruyen'],
        mac = json['mac'];

  Map<String, dynamic> toJson() => {
    'maphong': maphong,
    'mabenhnhan': mabenhnhan,
    'hoten': hoten,
    'gioitinh': gioitinh,
    'ngaysinh': ngaysinh,
    'nhietdo': nhietdo,
    'nhiptim': nhiptim,
    'nongdooxy': nongdooxy,
    'dungdichtruyen': dungdichtruyen,
    'mac': mac,
  };

  @override
  String toString() {
    return '$maphong -$mabenhnhan -$hoten - $gioitinh - $ngaysinh - $nhietdo -$nhiptim - $nongdooxy - $dungdichtruyen';
  }
}
