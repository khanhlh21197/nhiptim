class Loi {
  String ten;
  String ngay;
  String gio;

  Loi(this.ten, this.ngay, this.gio);

  Loi.fromJson(Map<String, dynamic> json)
      : ten = json['ten'],
        ngay = json['ngay'],
        gio = json['gio'];

  Map<String, dynamic> toJson() => {
        'ten': ten,
        'ngay': ngay,
        'gio': gio,
      };

  @override
  String toString() {
    return '$ten -$ngay  - $gio';
  }
}
