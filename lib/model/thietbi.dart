class ThietBi {
  String userid;
  String mathietbi;
  String vitri;
  String soloi;
  String dienap;
  String trangthai;
  String TDS;
  String Loi1;
  String Loi2;
  String Loi3;
  String Loi4;
  String Loi5;
  String Loi6;
  String Loi7;
  String Loi8;
  String Loi9;
  String Loi10;
  String Loi11;
  String Loi12;
  String ngaykichhoat;
  String timeupdate;
  String mac;

  ThietBi(
      this.userid,
      this.mathietbi,
      this.vitri,
      this.soloi,
      this.dienap,
      this.trangthai,
      this.TDS,
      this.Loi1,
      this.Loi2,
      this.Loi3,
      this.Loi4,
      this.Loi5,
      this.Loi6,
      this.Loi7,
      this.Loi8,
      this.Loi9,
      this.Loi10,
      this.Loi11,
      this.Loi12,
      this.ngaykichhoat,
      this.timeupdate,
      this.mac);

  ThietBi.fromJson(Map<String, dynamic> json)
      : mathietbi = json['mathietbi'],
        userid = json['userid'],
        vitri = json['vitri'],
        soloi = json['soloi'],
        dienap = json['dienap'],
        trangthai = json['trangthai'],
        TDS = json['TDS'],
        Loi1 = json['Loi1'],
        Loi2 = json['Loi2'],
        Loi3 = json['Loi3'],
        Loi4 = json['Loi4'],
        Loi5 = json['Loi5'],
        Loi6 = json['Loi6'],
        Loi7 = json['Loi7'],
        Loi8 = json['Loi8'],
        Loi9 = json['Loi9'],
        Loi10 = json['Loi10'],
        Loi11 = json['Loi11'],
        Loi12 = json['Loi12'],
        mac = json['mac'],
        ngaykichhoat = json['ngaykichhoat'],
        timeupdate = json['timeupdate'];

  Map<String, dynamic> toJson() => {
        'mathietbi': mathietbi,
        'userid': userid,
        'vitri': vitri,
        'soloi': soloi,
        'dienap': dienap,
        'trangthai': trangthai,
        'TDS': TDS,
        'Loi1': Loi1,
        'Loi2': Loi2,
        'Loi3': Loi3,
        'Loi4': Loi4,
        'Loi5': Loi5,
        'Loi6': Loi6,
        'Loi7': Loi7,
        'Loi8': Loi8,
        'Loi9': Loi9,
        'Loi10': Loi10,
        'Loi11': Loi11,
        'Loi12': Loi12,
        'ngaykichhoat': ngaykichhoat,
        'timeupdate': timeupdate,
        'mac': mac,
      };

  @override
  String toString() {
    return '$mathietbi '
        '- $userid '
        '- $vitri '
        '- $soloi '
        '- $dienap '
        '- $trangthai '
        '- $TDS '
        '- $Loi1 '
        '- $Loi2 '
        '- $Loi3 '
        '- $Loi4 '
        '- $Loi5 '
        '- $Loi6 '
        '- $Loi7 '
        '- $Loi8 '
        '- $Loi9 '
        '- $Loi10 '
        '- $Loi11 '
        '- $Loi12 '
        '- $ngaykichhoat '
        '- $timeupdate ';
  }
}
