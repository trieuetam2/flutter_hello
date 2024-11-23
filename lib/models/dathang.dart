class Dathang {
  int id_dathang;
  String madathang;
  String makh;
  String trangthai;
  int tongtien;
  DateTime ngaydathang;
  String giaohang;
  int id_kh;
  String tenkh;
  String sdt;
  String diachi;

  Dathang({
    required this.id_dathang,
    required this.madathang,
    required this.makh,
    required this.trangthai,
    required this.tongtien,
    required this.ngaydathang,
    required this.giaohang,
    required this.id_kh,
    required this.tenkh,
    required this.sdt,
    required this.diachi
  });

  // Updated factory constructor for creating from JSON
  factory Dathang.fromJson(Map<String, dynamic> json) {
    return Dathang(
      id_dathang: int.parse(json['id_dathang'].toString()), // Ensure it's parsed to int
      madathang: json['madathang'],
      makh: json['makh'],
      trangthai: json['trangthai'],
      tongtien: int.parse(json['tongtien'].toString()), // Parsing to int
      ngaydathang: DateTime.parse(json['ngaydathang']), // Parsing string to DateTime
      giaohang: json['giaohang'],
      id_kh: int.parse(json['id_kh'].toString()), 
      tenkh: json['tenkh'], 
      sdt: json['sdt'],
      diachi: json['diachi'],
    );
  }

  // Updated toJson method for converting object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id_dathang': id_dathang.toString(),
      'madathang': madathang,
      'makh': makh,
      'trangthai': trangthai,
      'tongtien': tongtien.toString(),
      'ngaydathang': ngaydathang.toIso8601String(), // Format DateTime to ISO string
      'giaohang': giaohang,
      'id_kh': id_kh.toString(),
      'tenkh': tenkh,
      'sdt': sdt,
      'diachi': diachi
    };
  }
}