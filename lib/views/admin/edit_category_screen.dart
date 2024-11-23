import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_connection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class EditCategoryScreen extends StatefulWidget {
  final String productId;

  EditCategoryScreen({required this.productId});

  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  late Map<String, dynamic> product = {}; // Khởi tạo product rỗng

  TextEditingController? tenDanhMucController;

  @override
  void initState() {
    super.initState();
    fetchCategoryDetails();
  }

  // Lấy chi tiết sản phẩm từ API
  Future<void> fetchCategoryDetails() async {
    final response = await http.post(
      Uri.parse(API.editCategory),
      body: {'id_danhmuc': widget.productId},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['editCategory'] == true && jsonResponse['product'] != null) {
        setState(() {
          product = jsonResponse['product'];
          print(product);
          tenDanhMucController = TextEditingController(text: product['ten_danhmuc']);
        });
      } else {
        print('Failed to fetch category details');
      }
    } else {
      print('Failed to fetch category details: ${response.statusCode}');
    }
  }

  Future<void> saveCategory() async {
  final response = await http.post(
    Uri.parse(API.updateCategory),
    body: {
      'id_danhmuc': widget.productId, 
      'ten_danhmuc': product['ten_danhmuc'],      
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (jsonResponse['updateCategory'] == true) {
       Navigator.pop(context, true);
    } else {
      print('Failed to update category');
      Fluttertoast.showToast(msg: 'Lỗi cập nhật sản phẩm');
    }
  } else {
    print('Failed to update category: ${response.statusCode}');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cập nhập danh mục'),
      ),
      body: product.isEmpty
          ? Center(child: CircularProgressIndicator()) // Chờ khi dữ liệu được tải
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: tenDanhMucController,
                    decoration: InputDecoration(labelText: 'Tên danh mục'),
                    onChanged: (value) {
                      setState(() {
                        product['ten_danhmuc'] = value; // Cập nhật giá trị trong category
                      });
                    },
                  ),
                  
                  ElevatedButton(
                    onPressed: () {
                      saveCategory();
                    },
                    child: Text('Save Changes'),
                  ),
                ],
              ),
            ),
    );
  }


}
