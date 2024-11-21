class Danhmuc {
  int id_danhmuc;
  String ten_danhmuc;
  String anh_danhmuc;

  Danhmuc(this.id_danhmuc, this.ten_danhmuc, this.anh_danhmuc);

  factory Danhmuc.fromJson(Map<String, dynamic> json){
    return Danhmuc(
      int.parse(json['id_danhmuc']), 
      json['ten_danhmuc'],
      json['anh_danhmuc'],
    );
  }

  Map<String, dynamic> toJson() =>{
    'id_danhmuc': id_danhmuc.toString(),
    'ten_danhmuc': ten_danhmuc,
    'anh_danhmuc': anh_danhmuc,
  };
}