class ChitietDonhang {
  int id_ctdonhang;
  String madathang;
  String makh;
  int id_sanpham;
  String tensp;
  int soluong;
  int giamgia;
  int giatien;
  int tongtien;
  String trangthai;
  DateTime ngaydat;
  int id_dathang;
  int id_kh;

  // Updated constructor with all the fields
  ChitietDonhang({
    required this.id_ctdonhang,
    required this.madathang,
    required this.makh,
    required this.id_sanpham,
    required this.tensp,
    required this.soluong,
    required this.giamgia,
    required this.giatien,
    required this.tongtien,
    required this.trangthai,
    required this.ngaydat,
    required this.id_dathang,
    required this.id_kh,
  });

  // Updated factory constructor for creating from JSON
  factory ChitietDonhang.fromJson(Map<String, dynamic> json) {
    return ChitietDonhang(
      id_ctdonhang: int.parse(json['id_ctdonhang'].toString()), // Parsing to int
      madathang: json['madathang'],
      makh: json['makh'],
      id_sanpham: int.parse(json['id_sanpham'].toString()), // Parsing to int
      tensp: json['tensp'],
      soluong: int.parse(json['soluong'].toString()), // Parsing to int
      giamgia: int.parse(json['giamgia'].toString()), // Parsing to int
      giatien: int.parse(json['giatien'].toString()), // Parsing to int
      tongtien: int.parse(json['tongtien'].toString()), // Parsing to int
      trangthai: json['trangthai'],
      ngaydat: DateTime.parse(json['ngaydat']), // Parsing string to DateTime
      id_dathang: int.parse(json['id_dathang'].toString()), // Parsing to int
      id_kh: int.parse(json['id_kh'].toString()), // Parsing to int
    );
  }

  // Updated toJson method for converting object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id_ctdonhang': id_ctdonhang.toString(),
      'madathang': madathang,
      'makh': makh,
      'id_sanpham': id_sanpham.toString(),
      'tensp': tensp,
      'soluong': soluong.toString(),
      'giamgia': giamgia.toString(),
      'giatien': giatien.toString(),
      'tongtien': tongtien.toString(),
      'trangthai': trangthai,
      'ngaydat': ngaydat.toIso8601String(), // Format DateTime to ISO string
      'id_dathang': id_dathang.toString(),
      'id_kh': id_kh.toString(),
    };
  }
}
