// To parse this JSON data, do
//
//     final deviceStatus = deviceStatusFromJson(jsonString);

import 'dart:convert';

DeviceStatus deviceStatusFromJson(String str) => DeviceStatus.fromJson(json.decode(str));

String deviceStatusToJson(DeviceStatus data) => json.encode(data.toJson());

class DeviceStatus {
  DeviceStatus({
    this.dienap,
    this.trangthai,
    this.tds,
  });

  String dienap;
  String trangthai;
  String tds;

  factory DeviceStatus.fromJson(Map<String, dynamic> json) => DeviceStatus(
    dienap: json["dienap"],
    trangthai: json["trangthai"],
    tds: json["TDS"],
  );

  Map<String, dynamic> toJson() => {
    "dienap": dienap,
    "trangthai": trangthai,
    "TDS": tds,
  };
}
