import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_connection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class EditProductScreen extends StatefulWidget {
  final String productId;

  EditProductScreen({required this.productId});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late Map<String, dynamic> product = {}; // Khởi tạo product rỗng

  TextEditingController? nameController;
  TextEditingController? priceController;
  TextEditingController? motaController;
  TextEditingController? discountController;
  TextEditingController? soluongController;
  TextEditingController? danhmucController;

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
    fetchCategories();
  }


 List<Map<String, String>> categories = [];

  // Fetch categories from API
  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(API.showCategory));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['showCategory'] == true) {
          // Process categories into a list of maps containing 'id_danhmuc' and 'ten_danhmuc'
          List<Map<String, String>> tempCategories = [];
          for (var category in data['categories']) {
            tempCategories.add({
              'id_danhmuc': category['id_danhmuc'],
              'ten_danhmuc': category['ten_danhmuc'],
            });
          }
          setState(() {
            categories = tempCategories;
          });
        } else {
          Fluttertoast.showToast(msg: "No categories found");
        }
      } else {
        Fluttertoast.showToast(msg: "Failed to load categories");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error fetching categories: $e");
    }
  }

  // Lấy chi tiết sản phẩm từ API
  Future<void> fetchProductDetails() async {
    final response = await http.post(
      Uri.parse(API.showEditProduct),
      body: {'id_sanpham': widget.productId},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['showEditProduct'] == true && jsonResponse['product'] != null) {
        setState(() {
          product = jsonResponse['product'];
          nameController = TextEditingController(text: product['tensp']);
          priceController = TextEditingController(text: product['giasp'].toString());
          motaController = TextEditingController(text: product['mota']);
          discountController = TextEditingController(text: product['discount'].toString());
          soluongController = TextEditingController(text: product['soluong'].toString());
          danhmucController = TextEditingController(text: product['id_danhmuc'].toString());
        });
      } else {
        print('Failed to fetch product details');
      }
    } else {
      print('Failed to fetch product details: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cập nhập sản phẩm'),
      ),
      body: product.isEmpty
          ? Center(child: CircularProgressIndicator()) // Chờ khi dữ liệu được tải
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Tên sản phẩm'),
                    onChanged: (value) {
                      setState(() {
                        product['tensp'] = value; // Cập nhật giá trị trong product
                      });
                    },
                  ),
                  TextField(
                    controller: priceController,
                    decoration: InputDecoration(labelText: 'Giá'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        product['giasp'] = value; // Cập nhật giá trị trong product
                      });
                    },
                  ),
                  TextField(
                    controller: motaController,
                    decoration: InputDecoration(labelText: 'Mô tả'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        product['mota'] = value; // Cập nhật giá trị trong product
                      });
                    },
                  ),
                  TextField(
                    controller: discountController,
                    decoration: InputDecoration(labelText: 'Giảm giá'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        product['discount'] = value; // Cập nhật giá trị trong product
                      });
                    },
                  ),
                  TextField(
                    controller: soluongController,
                    decoration: InputDecoration(labelText: 'Số lượng'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        product['soluong'] = value; // Cập nhật giá trị trong product
                      });
                    },
                  ),
                  // TextField(
                  //   controller: danhmucController,
                  //   decoration: InputDecoration(labelText: 'Danh mục'),
                  //   keyboardType: TextInputType.number,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       product['id_danhmuc'] = value; // Cập nhật giá trị trong product
                  //     });
                  //   },
                  // ),

DropdownButtonFormField<String>(
  value: categories.isNotEmpty
      ? product['id_danhmuc']?.toString() ?? categories[0]['id_danhmuc']?.toString()
      : null,  // Fallback if categories are not loaded
  items: categories.map((category) {
    return DropdownMenuItem<String>(
      value: category['id_danhmuc']?.toString(),  // Convert to String
      child: Text("${category['id_danhmuc']} - ${category['ten_danhmuc']}"),
    );
  }).toList(),
  onChanged: (newValue) {
    setState(() {
      product['id_danhmuc'] = newValue;  // We store the selected value as a String
    });
  },
  decoration: InputDecoration(
    labelText: "Danh mục",
    prefixIcon: Icon(Icons.category),
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng chọn danh mục';
    }
    return null;
  },
),


                  // Thêm các trường khác nếu cần
                  ElevatedButton(
                    onPressed: () {
                      // Hàm xử lý khi lưu thông tin sản phẩm
                      saveProduct();
                    },
                    child: Text('Save Changes'),
                  ),
                ],
              ),
            ),
    );
  }

Future<void> saveProduct() async {
  final response = await http.post(
    Uri.parse(API.updateProduct),
    body: {
      'id_sanpham': widget.productId,  // Giả sử id_sanpham là chuỗi
      'tensp': product['tensp'],       // Giả sử tên sản phẩm là chuỗi
      'giasp': product['giasp'].toString(),  // Nếu giasp là int, chuyển thành String
      'mota': product['mota'],         // Giả sử mô tả là chuỗi
      'discount': product['discount'].toString(),  // Nếu discount là int, chuyển thành String
      'soluong': product['soluong'].toString(),  // Nếu soluong là int, chuyển thành String
      'id_danhmuc': product['id_danhmuc'].toString(),  // Nếu id_danhmuc là int, chuyển thành String
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (jsonResponse['updateProduct'] == true) {
       Navigator.pop(context, true);
    } else {
      print('Failed to update product');
      Fluttertoast.showToast(msg: 'Lỗi cập nhật sản phẩm');
    }
  } else {
    print('Failed to update product: ${response.statusCode}');
  }
}

}
