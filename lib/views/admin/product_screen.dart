import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_connection.dart';
import 'package:flutter_application_1/views/admin/add_product_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  // List to hold product data
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    // Fetch products when the screen is initialized
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse(API.showProduct));

    if (response.statusCode == 200) {
      // Parse the JSON response as a Map
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Ensure 'showProduct' is true and 'products' contains the list of products
      if (jsonResponse['showProduct'] == true && jsonResponse['products'] != null) {
        List<dynamic> productList = jsonResponse['products'];

        setState(() {
          // Convert product data into a list of maps and update state
          products = productList.map((product) {
            return {
              "tensp": product['tensp'],
              "anhsp": product['anhsp'],
              "giasp": product['giasp'],
            };
          }).toList();
        });
      }
    } else {
      print('Failed to load products: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manager Product"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              // Navigate to AddProductScreen and wait for the result
              final result = await Get.to(() => AddProductScreen());

              // If result is true, refresh the product list
              if (result != null && result) {
                fetchProducts(); // Call fetchProducts to refresh the list
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: products.isEmpty
            ? Container() // No loading spinner or message, just an empty body when products are not fetched
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  var product = products[index];

                  return Card(
     
                  child: ListTile(
                    leading: Image.asset(
                      // Kiểm tra nếu đường dẫn hợp lệ, nếu không sử dụng hình ảnh mặc định
                      (product["anhsp"] != null && product["anhsp"].isNotEmpty)
                          ? product["anhsp"]  // Nếu có đường dẫn hợp lệ
                          : 'assets/img/pig.png',  // Nếu không, sử dụng hình ảnh mặc định
                      width: 50,  // Bạn có thể thay đổi kích thước của ảnh nếu cần
                      height: 50,
                      fit: BoxFit.cover,  // Điều chỉnh cách hiển thị hình ảnh
                    ),
                    title: Text(product['tensp']),
                    subtitle: Text('Price: ${product['giasp']} VND'),
                  )

                  );
                },
              ),
      ),
    );
  }
}
