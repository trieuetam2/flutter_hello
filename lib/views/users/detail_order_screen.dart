import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_connection.dart';
import 'package:http/http.dart' as http;

class DetailOrderScreen extends StatefulWidget {
  final String productId;

  DetailOrderScreen({required this.productId});

  @override
  _DetailOrderScreenState createState() => _DetailOrderScreenState();
}

class _DetailOrderScreenState extends State<DetailOrderScreen> {
  List<Map<String, dynamic>> productDetails = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  Future<void> fetchOrderDetails() async {
    final response = await http.post(
      Uri.parse(API.showdetailOrder),
      body: {
        'id_dathang': widget.productId,
      },
    );

    if (response.statusCode == 200) {
      try {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['showDetailOrder'] == true) {
          setState(() {
            productDetails = List<Map<String, dynamic>>.from(jsonResponse['detailorder']);
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = jsonResponse['message'] ?? 'Detail order not found';
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
        errorMessage = 'Failed to fetch order details. Status code: ${response.statusCode}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết đơn hàng'),
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
                        // Customer Information
                        Text(
                          'Thông tin khách hàng',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: 16),
                        buildCustomerInfo(),
                        SizedBox(height: 24),

                        // Order details
                        Text(
                          'Danh sách sản phẩm',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: 16),
                        buildProductList(),
                        SizedBox(height: 24),

                        // Order status and total
                        Text(
                          'Thông tin đơn hàng',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: 16),
                        buildOrderInfo(),
                      ],
                    ),
                  ),
                ),
    );
  }

  // Build Customer Info
  Widget buildCustomerInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tên khách hàng: ${productDetails.isNotEmpty ? productDetails[0]['tenkh'] ?? 'N/A' : 'N/A'}', style: TextStyle(fontSize: 18)),
        SizedBox(height: 8),
        Text('SĐT: ${productDetails.isNotEmpty ? productDetails[0]['sdt'] ?? 'N/A' : 'N/A'}', style: TextStyle(fontSize: 18)),
        SizedBox(height: 8),
        Text('Địa chỉ: ${productDetails.isNotEmpty ? productDetails[0]['diachi'] ?? 'N/A' : 'N/A'}', style: TextStyle(fontSize: 18)),
      ],
    );
  }

  // Build Product List
  Widget buildProductList() {
    return productDetails.isNotEmpty
        ? Column(
            children: productDetails.map((detail) {
              final int quantity = detail['soluong'] ?? 0;
              final double price = double.tryParse(detail['giatien'].toString()) ?? 0.0;
              final double totalPrice = quantity * price;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name with overflow handling
                      Text(
                        'Sản phẩm: ${detail['tensp'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      // Quantity, Price, and Total Price
                      Text('Số lượng: ${detail['soluong'] ?? 'N/A'}', style: TextStyle(fontSize: 16)),
                      Text('Giá: ${detail['giatien'] ?? 0} đ', style: TextStyle(fontSize: 16)),
                      Text(
                        'Thành tiền: ${totalPrice.toStringAsFixed(0)} đ',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          )
        : Center(child: Text('No products in this order'));
  }

  // Build Order Info (Status and Total)
  Widget buildOrderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Trạng thái: ${productDetails.isNotEmpty ? productDetails[0]['trangthai'] ?? 'N/A' : 'N/A'}', style: TextStyle(fontSize: 18)),
        SizedBox(height: 8),
        Text(
          'Tổng tiền: ${productDetails.isNotEmpty ? productDetails.fold(0.0, (sum, item) {
            final int quantity = item['soluong'] ?? 0;
            final double price = double.tryParse(item['giatien'].toString()) ?? 0.0;
            return sum + (quantity * price);
          }).toStringAsFixed(0) : 'N/A'} đ',
          style: TextStyle(fontSize: 20, color: Colors.blue.shade700, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
