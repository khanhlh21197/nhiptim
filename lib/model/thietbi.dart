import 'package:flutter/cupertino.dart';

class ThietBi {
  String mabenhnhan;
  String maphong;
  String hoten;
  String gioitinh;
  String ngaysinh;
  String sodienthoai;
  String diachi;
  String thoigian;
  // String nhietdo;
  // String nhiptim;
  // String nongdooxy;
  String mac;
  Color color;
  Color color1;
  Color color2;
  List<dynamic> id;

  ThietBi(this.mabenhnhan, this.maphong, this.hoten, this.gioitinh, this.ngaysinh,
      this.sodienthoai, this.diachi, this.mac);

  ThietBi.fromJson(Map<String, dynamic> json)
      : mabenhnhan = json['mabenhnhan'],
        maphong = json['maphong'],
        hoten = json['hoten'],
        gioitinh = json['gioitinh'],
        ngaysinh = json['ngaysinh'],
        sodienthoai = json['sodienthoai'],
        diachi = json['diachi'],
        mac = json['mac'];

  Map<String, dynamic> toJson() => {
        'mabenhnhan': mabenhnhan,
        'maphong': maphong,
        'hoten': hoten,
        'gioitinh': gioitinh,
        'ngaysinh': ngaysinh,
        'sodienthoai': sodienthoai,
        'diachi': diachi,
        'mac': mac,
      };

  @override
  String toString() {
    return '$mabenhnhan -$maphong  - $hoten - $gioitinh - $ngaysinh '
        '-$sodienthoai -$diachi';
  }
}
