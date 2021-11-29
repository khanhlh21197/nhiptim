import 'package:flutter/cupertino.dart';

class ThietBi {
  String magiamsat;
  String madiadiem;
  String hoten;
  String gioitinh;
  String ngaysinh;
  String sodienthoai;
  String diachi;
  String giosang;
  String giochieu;
  String thoigian;
  // String nhietdo;
  // String nhiptim;
  // String nongdooxy;
  String mac;
  Color color;
  Color color1;
  Color color2;
  List<dynamic> id;

  ThietBi(this.magiamsat, this.madiadiem, this.hoten, this.gioitinh, this.ngaysinh,
      this.sodienthoai, this.diachi,
      this.giosang, this.giochieu, this.mac);

  ThietBi.fromJson(Map<String, dynamic> json)
      : magiamsat = json['magiamsat'],
        madiadiem = json['madiadiem'],
        hoten = json['hoten'],
        gioitinh = json['gioitinh'],
        ngaysinh = json['ngaysinh'],
        sodienthoai = json['sodienthoai'],
        diachi = json['diachi'],
        giosang = json['giosang'],
        giochieu = json['giochieu'],
        mac = json['mac'];

  Map<String, dynamic> toJson() => {
        'magiamsat': magiamsat,
        'madiadiem': madiadiem,
        'hoten': hoten,
        'gioitinh': gioitinh,
        'ngaysinh': ngaysinh,
        'sodienthoai': sodienthoai,
        'diachi': diachi,
        'giosang': giosang,
        'giochieu': giochieu,
        'mac': mac,
      };

  @override
  String toString() {
    return '$magiamsat -$madiadiem  - $hoten - $gioitinh - $ngaysinh '
        '-$sodienthoai -$diachi - $giosang - $giochieu';
  }
}
