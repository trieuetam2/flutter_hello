// HomeScreen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/users/HomeScreenController.dart';
import 'package:flutter_application_1/models/danhmuc.dart';
import 'package:flutter_application_1/services/api_connection.dart';
import 'package:flutter_application_1/views/users/category_tag_screen.dart';
import 'package:flutter_application_1/views/users/detail_product_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeScreenController controller = Get.put(HomeScreenController()); // GetX controller

  @override
  void initState() {
    super.initState();
    controller.fetchProducts(); // Fetch products when screen initializes
    controller.fetchCategory(); // Fetch categories when screen initializes
  }

  String formatToVND(double value) {
  final formatter = NumberFormat.currency(
    locale: 'vi_VN',  // Vietnamese locale
    symbol: '₫',      // Vietnamese Dong symbol
    decimalDigits: 0, // Optional: set number of decimal digits
  );
  
  return formatter.format(value);
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
            child: Obx(
              () => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final category = controller.categories[index];
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryTagScreen(
                              productId: category.id_danhmuc.toString(),
                              productName: category.ten_danhmuc.toString(),
                              productImg: category.anh_danhmuc.toString(),
                            ),
                          ),
                        );
                      },
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
                    ),
                  );
                },
              ),
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

          // GridView for products
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () => controller.products.isEmpty
                    ? Container()
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: controller.products.length,
                        itemBuilder: (context, index) {
                          var product = controller.products[index];
                          return Card(
                            elevation: 5,
                            child: InkWell(
                              onTap: () async {
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
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      product["anhsp"] ?? 'assets/img/pig.png',
                                      width: double.infinity,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      product['tensp'],
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                                    child: Text(
                                      '${formatToVND(double.parse(product['giasp']))}',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade400),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
