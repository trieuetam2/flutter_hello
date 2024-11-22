// DetailProductScreen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/cartitem.dart';
import 'package:flutter_application_1/services/api_connection.dart';
import 'package:flutter_application_1/services/cart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class DetailProductScreen extends StatefulWidget {
  final String productId;

  DetailProductScreen({required this.productId});

  @override
  _DetailProductScreenState createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  Map<String, dynamic> productDetail = {};
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  Future<void> fetchProductDetails() async {
    final response = await http.post(
      Uri.parse(API.showDetailProduct), 
      body: {
        'id_sanpham': widget.productId,  // Send the product id as parameter in POST request
      },
    );

    if (response.statusCode == 200) {
      try {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['showDetailProduct'] == true) {
          setState(() {
            productDetail = jsonResponse['product'];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = jsonResponse['message'] ?? 'Product not found';
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          errorMessage = 'Error parsing JSON: $e';
          isLoading = false;
        });
      }
    } else {
      setState(() {
        errorMessage = 'Failed to fetch product details. Status code: ${response.statusCode}';
        Fluttertoast.showToast(msg: widget.productId); // For debugging
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết sản phẩm'),
        backgroundColor: Colors.blue.shade400, 
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Center the product image
                        Center(
                          child: Image.asset(
                            productDetail['anhsp'],
                            height: 350,
                            fit: BoxFit.cover, // Ensures the image fits well in the box
                          ),
                        ),
                        SizedBox(height: 16),

                        // Product Name
                        Text(
                          productDetail['tensp'],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),

                        // Product Price
                        Text(
                          'Giá: ${productDetail['giasp']} VND',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.green.shade600,
                          ),
                        ),
                        SizedBox(height: 16),

                        // Product Soluong (Stock Quantity)
                        Text(
                          'Số lượng: ${productDetail['soluong']}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.green.shade600,
                          ),
                        ),
                        SizedBox(height: 16),

                        // Product Description
                        Text(
                          'Description: ${productDetail['mota']}',
                          style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                        ),
                        SizedBox(height: 16),

                        // Add to Cart Button, aligned to the right with padding and border radius
                        Align(
                          alignment: Alignment.centerRight, // Align button to the right
                          child: ElevatedButton(
                            onPressed: () async {
                              // Retrieve existing cart items from SharedPreferences
                              List<CartItem> cartItems = await SharedPreferencesCart.getCartItems();
                              
                              // Check if the product is already in the cart
                              bool isProductInCart = cartItems.any((cartItem) =>
                                  cartItem.id_sanpham == productDetail['id_sanpham'].toString());
                              
                              if (isProductInCart) {
                                // If the product is already in the cart, show a toast and don't add it
                                Fluttertoast.showToast(msg: 'Sản phẩm đã có trong giỏ hàng');
                              } else {
                                // If the product is not in the cart, create a new CartItem and add it
                                final cartItem = CartItem(
                                  id_sanpham: productDetail['id_sanpham'].toString(),
                                  tensp: productDetail['tensp'].toString(),
                                  anhsp: productDetail['anhsp'].toString(),
                                  giasp: productDetail['giasp'] is int
                                      ? productDetail['giasp']
                                      : int.parse(productDetail['giasp'].toString()),
                                  soluong: 1, // Default to 1 (initial quantity)
                                  maxQuantity: productDetail['soluong'],
                                );

                                // Add the new CartItem to the existing cart and save it to SharedPreferences
                                cartItems.add(cartItem);
                                await SharedPreferencesCart.saveCartItems(cartItems);

                                Fluttertoast.showToast(msg: 'Sản phẩm đã được thêm vào giỏ hàng');
                              }
                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade400,
                              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              'Thêm vào giỏ hàng',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 16), // Add some space at the bottom
                      ],
                    ),
                  ),
                ),
    );
  }
}
