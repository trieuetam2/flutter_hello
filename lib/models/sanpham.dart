class Sanpham {
  int id_sanpham;
  String tensp;
  String anhsp;
  String giasp;
  String mota;
  int discount;
  int soluong;
  int id_danhmuc;

  Sanpham(this.id_sanpham, this.tensp, this.anhsp, this.giasp, this.mota, this.discount, this.soluong, this.id_danhmuc);

  factory Sanpham.fromJson(Map<String, dynamic> json){
    return Sanpham(
      int.parse(json['id_sanpham']), 
      json['tensp'],
      json['anhsp'],
      json['giasp'],
      json['mota'],
      int.parse(json['discount']),
      int.parse(json['soluong']),
      int.parse(json['id_danhmuc']),
    );
  }

  Map<String, dynamic> toJson() =>{
    'id_sanpham': id_sanpham.toString(),
    'tensp': tensp,
    'anhsp': anhsp,
    'giasp': giasp,
    'mota': mota,
    'discount': discount.toString(),
    'soluong': soluong.toString(),
    'id_danhmuc': id_danhmuc.toString(),
  };
}