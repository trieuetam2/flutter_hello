import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_connection.dart';
import 'package:flutter_application_1/views/users/detail_product_screen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CategoryTagScreen extends StatefulWidget {
  final String productId;  // Declare the parameter
  final String productName;  // Declare the parameter
  final String productImg;  // Declare the parameter

  // Constructor that takes productId, productName, and productImg as parameters
  CategoryTagScreen({
    required this.productId,
    required this.productName,
    required this.productImg,
  });

  @override
  _CategoryTagScreenState createState() => _CategoryTagScreenState();
}

class _CategoryTagScreenState extends State<CategoryTagScreen> {
  List<dynamic> products = []; // To hold the products fetched

  @override
  void initState() {
    super.initState();
    fetchProductsByCategory(widget.productId); // Fetch products when the screen is initialized
  }

  // Function to fetch products by category ID
  Future<void> fetchProductsByCategory(String categoryId) async {
    final response = await http.post(
      Uri.parse(API.showCateByID), // Replace with your actual PHP API URL
      body: {
        'id_danhmuc': categoryId, // Only send category ID
      },
    );

    // if (response.statusCode == 200) {
    //   // Decode the JSON response
    //   Map<String, dynamic> data = jsonDecode(response.body);

    //   if (data['showCateById'] == true) {
    //     setState(() {
    //       products = data['productss']; // Store the list of products
    //     });
    //   } else {
    //     // Show a message if no products are found
    //     showToast("No products found in this category");
    //   }
    // } else {
    //   // Handle the error if the request fails
    //   showToast("Failed to load products");
    // }

    if (response.statusCode == 200) {
      // Parse the JSON response as a Map
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Ensure 'showProduct' is true and 'products' contains the list of products
      if (jsonResponse['showCateById'] == true && jsonResponse['productss'] != null) {
        List<dynamic> productList = jsonResponse['productss'];

        setState(() {
          // Convert product data into a list of maps and update state
          products = productList.map((product) {
            return {
              "id_sanpham": product['id_sanpham'].toString(),
              "tensp": product['tensp'],
              "anhsp": product['anhsp'],
              "giasp": product['giasp'].toString(),
              "soluong": product['soluong'].toString(),
            };
          }).toList();
        });
      }
    } else {
      print('Failed to load products: ${response.statusCode}');
    }

  }

  // Function to show a toast message
  void showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 16), // Khoảng cách giữa ảnh và title
            Expanded(
              child: Text(
                'Danh mục: ${widget.productName}', // Tiêu đề AppBar
                style: TextStyle(color: Colors.white), // Màu chữ trắng
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(25), // Bo tròn ảnh thành hình tròn với bán kính 25
              child: Image.asset(
                widget.productImg, // Đường dẫn tới ảnh trong thư mục assets
                width: 40,
                height: 40,
                fit: BoxFit.cover, // Đảm bảo ảnh không bị kéo giãn
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade400, // Màu nền của AppBar
        foregroundColor: Colors.white, // Màu chữ của AppBar
      ),

  body: products.isEmpty
    ? Center(child: CircularProgressIndicator()) // Show a loading indicator while fetching data
    : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          var product = products[index];
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
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0), // Add top padding here
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Show product image
                    Image.asset(
                      product['anhsp'] != null && product['anhsp'].isNotEmpty
                          ? '${product['anhsp']}' // If there's an image path in assets
                          : 'assets/img/pig.png', // Use placeholder if no image
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                      child: Text(
                        product['tensp'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                      child: Text(
                        '${formatToVND(double.parse(product['giasp']))}',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade400),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),

    );
  }
}
