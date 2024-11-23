import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/admin/addProductController.dart';
import 'package:flutter_application_1/models/sanpham.dart';
import 'package:flutter_application_1/services/api_connection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:img_picker/img_picker.dart'; // For file handling
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _tenSPController = TextEditingController();
  final TextEditingController _anhSPController = TextEditingController();
  final TextEditingController _giaSPController = TextEditingController();
  final TextEditingController _motaController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _soluongController = TextEditingController();
  final TextEditingController _idDanhMucController = TextEditingController();

  final Addproductcontroller _addProduct = Get.put(Addproductcontroller());

  // List to hold fetched categories
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

  // Function to submit the form
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Create product model
      Sanpham addProductModel = Sanpham(
        1,
        _tenSPController.text.trim(),
        _anhSPController.text.trim(),
        _giaSPController.text.trim(),
        _motaController.text.trim(),
        int.tryParse(_discountController.text.trim()) ?? 0,
        int.tryParse(_soluongController.text.trim()) ?? 0,
        int.tryParse(_idDanhMucController.text.trim()) ?? 0,
      );

      bool addProductSuccess = await _addProduct.addProducts(addProductModel);

      if (addProductSuccess) {
        Fluttertoast.showToast(msg: 'Thêm sản phẩm thành công');
        setState(() {
          _tenSPController.clear();
          _giaSPController.clear();
          _motaController.clear();
          _discountController.clear();
          _soluongController.clear();
          _idDanhMucController.clear();
          Get.back(result: true);
        });
      } else {
        Fluttertoast.showToast(msg: 'Thêm sản phẩm thất bại');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();  // Fetch categories when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Thêm sản phẩm",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Product Name
              TextFormField(
                controller: _tenSPController,
                decoration: InputDecoration(
                  labelText: "Tên sản phẩm",
                  prefixIcon: Icon(Icons.production_quantity_limits),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên sản phẩm';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Product Price
              TextFormField(
                controller: _giaSPController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Giá",
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập giá';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Vui lòng chọn kiểu giá trị là số';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // Product Price
              TextFormField(
                controller: _motaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Mô tả",
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập Mô tả';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Vui lòng chọn kiểu Mô tả trị là số';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // Product Price
              TextFormField(
                controller: _discountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Giảm giá",
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập Giảm giá';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Vui lòng chọn kiểu Giảm giá trị là số';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // Product Price
              TextFormField(
                controller: _soluongController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Số lượng",
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập Số lượng';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Vui lòng chọn kiểu Số lượng trị là số';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Product Category
              DropdownButtonFormField<String>(
                value: categories.isNotEmpty ? categories[0]['id_danhmuc'] : null,
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category['id_danhmuc'],
                    child: Text("${category['id_danhmuc']} - ${category['ten_danhmuc']}"),
                  );
                }).toList(),
                onChanged: (newValue) {
                  _idDanhMucController.text = newValue!;  // Store the category ID
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
              SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(
                  "Thêm sản phẩm",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  side: BorderSide(color: Colors.white, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.2),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

