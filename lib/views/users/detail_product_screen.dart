// DetailProductScreen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_connection.dart';
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
      'id_sanpham': widget.productId,  // Gửi tham số qua body của POST
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
      Fluttertoast.showToast(msg: widget.productId); //return id_sanpham=0
      isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(productDetail['anhsp']),
                      SizedBox(height: 10),
                      Text(productDetail['tensp'], style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text('Price: ${productDetail['giasp']} VND'),
                      SizedBox(height: 10),
                      Text('Description: ${productDetail['mota']}'),
                    ],
                  ),
                ),
    );
  }
}
