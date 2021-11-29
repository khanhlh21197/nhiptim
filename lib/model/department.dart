import 'dart:convert';

import 'package:floor/floor.dart';

@entity
class Department {
  @primaryKey
  @ColumnInfo(name: 'diachi', nullable: false)
  final String diachi;
  @ColumnInfo(name: 'madiadiem', nullable: false)
  final String madiadiem;
  @ColumnInfo(name: 'sodienthoai', nullable: false)
  final String sodienthoai;
  @ColumnInfo(name: 'mac', nullable: false)
  String mac;


  Department(this.diachi, this.madiadiem, this.sodienthoai, this.mac);

  // String get departmentDiachiDecode {
  //   try {
  //     String s = diachi;
  //     List<int> ints = List();
  //     s = s.replaceAll('[', '');
  //     s = s.replaceAll(']', '');
  //     List<String> strings = s.split(',');
  //     for (int i = 0; i < strings.length; i++) {
  //       ints.add(int.parse(strings[i]));
  //     }
  //     return utf8.decode(ints);
  //   } catch (e) {
  //     return diachi;
  //   }
  // }

  Department.fromJson(Map<String, dynamic> json)
      : diachi = json['diachi'],
        madiadiem = json['madiadiem'],
        sodienthoai = json['sodienthoai'],
        mac = json['mac'];

  Map<String, dynamic> toJson() => {
        'diachi': diachi,
        'madiadiem': madiadiem,
        'sodienthoai': sodienthoai,
        'mac': mac,
      };
}
