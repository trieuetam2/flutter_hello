// home_screen_controller.dart
import 'dart:convert';
import 'package:flutter_application_1/services/api_connection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/danhmuc.dart';

class HomeScreenController extends GetxController {
  var products = <Map<String, dynamic>>[].obs;
  var categories = <Danhmuc>[].obs;

  // Hàm tải danh mục
  Future<void> fetchCategory() async {
    final response = await http.get(Uri.parse(API.showCategory));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['showCategory'] == true && jsonResponse['categories'] != null) {
        List<dynamic> cateList = jsonResponse['categories'];
        categories.value = cateList.map((cate) => Danhmuc.fromJson(cate)).toList();
      }
    }
  }

  // Hàm tải sản phẩm home page
  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse(API.showClientProduct));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['showProduct'] == true && jsonResponse['products'] != null) {
        List<dynamic> productList = jsonResponse['products'];
        products.value = productList.map((product) {
          return {
            "id_sanpham": product['id_sanpham'],
            "tensp": product['tensp'],
            "anhsp": product['anhsp'],
            "giasp": product['giasp'],
          };
        }).toList();
      }
    }
  }

  // Hàm lọc sản phẩm home page
  Future<void> filterProducts(String query) async {
    if (query.isEmpty) {
      fetchProducts();  // Nếu không có từ khóa, lấy tất cả sản phẩm
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(API.searchProduct),
        body: {'searchQuery': query},
      );

      if (response.statusCode == 200) {
        //print(products.value);
        final data = json.decode(response.body);
        if (data['searchProduct'] == true) {
          products.value = List<Map<String, dynamic>>.from(data['products'].map((product) {
            // Ensure each field is correctly typed
            return {
            "id_sanpham": product['id_sanpham'].toString(),
            "tensp": product['tensp'],
            "anhsp": product['anhsp'],
            "giasp": product['giasp'].toString(),
            "id_danhmuc": product['id_danhmuc'].toString(),
            };
          }));
        } else {
          products.value = [];
          fetchProducts();  // Nếu không có sản phẩm, tải lại tất cả
        }
      } else {
        Fluttertoast.showToast(msg: 'Tìm kiếm thất bại');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Lỗi khi tìm kiếm');
    }
  }
}
