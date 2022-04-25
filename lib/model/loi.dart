class Loi {
  String ten;
  String ngay;
  String gio;
  String mathietbi;
  String loi;
  String mac;

  Loi(this.ten, this.ngay, this.gio, this.loi, this.mathietbi, this.mac);

  Loi.fromJson(Map<String, dynamic> json)
      : ten = json['ten'],
        ngay = json['ngay'],
        mathietbi = json['mathietbi'],
        loi = json['loi'],
        mac = json['mac'],
        gio = json['gio'];

  Map<String, dynamic> toJson() => {
        'ten': ten,
        'ngay': ngay,
        'mac': mac,
        'mathietbi': mathietbi,
        'loi': loi,
        'gio': gio,
      };

  @override
  String toString() {
    return '$ten -$ngay  - $gio';
  }
}
