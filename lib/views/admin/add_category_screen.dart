import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/danhmuc.dart';
import 'package:flutter_application_1/services/api_connection.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controller for text fields
  final TextEditingController _idDanhMucController = TextEditingController();
  final TextEditingController _tenDanhMucController = TextEditingController();
  final TextEditingController _anhDanhMucController = TextEditingController();


Future<bool> addCategoryFunction(Danhmuc danhmuc) async {
  try {
    var res = await http.post(
      Uri.parse(API.addCategory),
      body: danhmuc.toJson(),
    );

    print('Response body: ${res.body}'); // Debugging line

    if (res.statusCode == 200) {
      var resbodySignup = jsonDecode(res.body);
      print('Decoded JSON: $resbodySignup'); // Debugging line

      return resbodySignup['successAddCategory'] == true;
    } else {
      throw Exception('Failed to add category');
    }
  } catch (e) {
    print('Error registering category: $e');
    Fluttertoast.showToast(msg: 'Error registering category: $e');
    return false;
  }
}

  // Function to submit the form
  void _submitForm() async{
    if (_formKey.currentState!.validate()) {

        //tao moi danhmuc
        Danhmuc addCategoryModel = Danhmuc(
          1,
          _tenDanhMucController.text.trim(),
          "",
        );

        bool addProductsuccess = await addCategoryFunction(addCategoryModel);
        

        if (addProductsuccess) {
          Fluttertoast.showToast(msg: 'Thêm danh mục thành công');
          setState(() {
            _tenDanhMucController.clear();
            Get.back(result: true);
          });
        } else {
          Fluttertoast.showToast(msg: 'Thêm danh mục thất bại');
        }

    }
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
              "Thêm danh mục",
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

        TextFormField(
          controller: _tenDanhMucController,
          decoration: InputDecoration(
            labelText: "Tên danh mục",
            prefixIcon: Icon(Icons.category), 
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập tên danh mục';
            }
            return null;
          },
        ),
        SizedBox(height: 16),

        // Submit Button
        ElevatedButton(
          onPressed: _submitForm,
          child: Text(
            "Thêm danh mục",
            style: TextStyle(color: Colors.white), // Màu chữ trắng
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // Màu nền nút (blue)
            side: BorderSide(color: Colors.white, width: 2), // Viền màu trắng
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32), // Bo tròn các góc
            ),
            elevation: 5, // Độ cao bóng đổ
            shadowColor: Colors.black.withOpacity(0.2), // Màu bóng đổ
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
