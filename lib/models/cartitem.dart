class CartItem {
  String id_sanpham;
  String tensp;
  String anhsp;
  int giasp;
  int soluong;
  int maxQuantity;
  bool selected;  // Include the selected field

  // Constructor
  CartItem({
    required this.id_sanpham,
    required this.tensp,
    required this.anhsp,
    required this.giasp,
    required this.soluong,
    required this.maxQuantity,
    this.selected = false,  // Default value for selected
  });

  // Convert CartItem to a Map (for storage, like SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'id_sanpham': id_sanpham,
      'tensp': tensp,
      'anhsp': anhsp,
      'giasp': giasp,
      'soluong': soluong,
      'maxQuantity': maxQuantity,
      'selected': selected,  // Add selected field here
    };
  }

  // Create a CartItem from a Map (for loading from storage)
  static CartItem fromMap(Map<String, dynamic> map) {
    return CartItem(
      id_sanpham: map['id_sanpham'],
      tensp: map['tensp'],
      anhsp: map['anhsp'],
      giasp: map['giasp'],
      soluong: map['soluong'],
      maxQuantity: map['maxQuantity'],
      selected: map['selected'] ?? false,  // Retrieve the selected field, default to false if null
    );
  }
}
