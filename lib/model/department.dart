import 'dart:convert';

import 'package:floor/floor.dart';

@entity
class Department {
  @primaryKey
  @ColumnInfo(name: 'tenphong', nullable: false)
  final String tenphong;
  @ColumnInfo(name: 'maphong', nullable: false)
  final String maphong;
  @ColumnInfo(name: 'mac', nullable: false)
  String mac;


  Department(this.tenphong, this.maphong,  this.mac);

  // String get departmenttenphongDecode {
  //   try {
  //     String s = tenphong;
  //     List<int> ints = List();
  //     s = s.replaceAll('[', '');
  //     s = s.replaceAll(']', '');
  //     List<String> strings = s.split(',');
  //     for (int i = 0; i < strings.length; i++) {
  //       ints.add(int.parse(strings[i]));
  //     }
  //     return utf8.decode(ints);
  //   } catch (e) {
  //     return tenphong;
  //   }
  // }

  Department.fromJson(Map<String, dynamic> json)
      : tenphong = json['tenphong'],
        maphong = json['maphong'],
        mac = json['mac'];

  Map<String, dynamic> toJson() => {
        'tenphong': tenphong,
        'maphong': maphong,
        'mac': mac,
      };
}
