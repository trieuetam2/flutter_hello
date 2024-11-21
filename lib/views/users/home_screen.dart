// HomeScreen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/danhmuc.dart';
import 'package:flutter_application_1/services/api_connection.dart';
import 'package:flutter_application_1/views/users/detail_product_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List to hold product data
  List<Map<String, dynamic>> products = [];
  List<Danhmuc> categories = [];

  @override
  void initState() {
    super.initState();
    // Fetch products when the screen is initialized
    fetchProducts();
    fetchCategory();
  }

  Future<void> fetchCategory() async {
    final response = await http.get(Uri.parse(API.showCategory));

    if (response.statusCode == 200) {
      // Parse the JSON response as a Map
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (jsonResponse['showCategory'] == true && jsonResponse['categories'] != null) {
        List<dynamic> cateList = jsonResponse['categories'];

        setState(() {
          categories = cateList.map((cate) => Danhmuc.fromJson(cate)).toList();
        });
      }
    } else {
      print('Failed to load category: ${response.statusCode}');
    }
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse(API.showClientProduct));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (jsonResponse['showProduct'] == true && jsonResponse['products'] != null) {
        List<dynamic> productList = jsonResponse['products'];

        setState(() {
          products = productList.map((product) {
            return {
              "id_sanpham": product['id_sanpham'],
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Danh mục section
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Image.asset(category.anh_danhmuc),
                      ),
                      SizedBox(height: 8),
                      Text(category.ten_danhmuc, textAlign: TextAlign.center),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Sản phẩm section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Sản phẩm nổi bật',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          
         Expanded(
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: products.isEmpty
        ? Container() // Empty container if no products
        : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 items per row
              crossAxisSpacing: 10, // Spacing between columns
              mainAxisSpacing: 10, // Spacing between rows
              childAspectRatio: 0.7, // Adjust the height/width ratio of each item
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index];

              return Card(
                elevation: 5, // Adds shadow for card
                child: InkWell(
                  onTap: () async {
                    // Navigate to detail page on tap
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailProductScreen(
                          productId: product['id_sanpham'],
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          (product["anhsp"] != null && product["anhsp"].isNotEmpty)
                              ? product["anhsp"]
                              : 'assets/img/pig.png',
                          width: double.infinity, // Make image fill the container
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Product Title
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          product['tensp'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Product Price
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Price: ${product['giasp']} VND'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
  ),
),

        ],
      ),
    );
  }
}
