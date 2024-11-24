import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_connection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DetailordersManageScreen extends StatefulWidget {
  final String productId;

  DetailordersManageScreen({required this.productId});

  @override
  _DetailordersManageScreenState createState() => _DetailordersManageScreenState();
}

class _DetailordersManageScreenState extends State<DetailordersManageScreen> {
  List<Map<String, dynamic>> productDetails = [];
  bool isLoading = true;
  String errorMessage = '';

  final TextEditingController _statusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  // Fetch order details from the server
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

Future<void> saveOrderStatus(String updatedStatus) async {
  try {
    final url = Uri.parse(API.updateOrderStatus);

    // Create the data payload
    final data = {
      'id_dathang': widget.productId, // Order ID from the productDetails list
      'trangthai': updatedStatus,     // Use the passed status
    };

    // Print the request body for debugging purposes
    print("Sending data: $data");

    // Make the POST request with proper headers
    final response = await http.post(
      url,
      body: data,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: 'Trạng thái đã được cập nhật');

      // After the status is updated, fetch the updated order details
      await fetchOrderDetails(); // Refresh the order details
    } else {
      Fluttertoast.showToast(msg: 'Lỗi khi cập nhật trạng thái');
    }
  } catch (e) {
    print('Error: $e');
    Fluttertoast.showToast(msg: 'Lỗi kết nối');
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
    // Set initial value of TextField based on the current order status
    if (productDetails.isNotEmpty) {
      _statusController.text = productDetails[0]['trangthai'] ?? 'N/A';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Mã đơn hàng: ${productDetails[0]['madathang']}'),
        SizedBox(height: 15),

DropdownButtonFormField<String>(
  value: productDetails[0]['trang_thai'] ?? null,  // Default value if not set
  items: [
    'Chờ xác nhận',
    'Chờ giao hàng',
    'Đang giao hàng',
    'Giao thành công',
  ].map((status) {
    return DropdownMenuItem<String>(
      value: status,  // Use status directly
      child: Text(status),
    );
  }).toList(),
  onChanged: (newValue) {
    setState(() {
      productDetails[0]['trang_thai'] = newValue;  // Update product status
      _statusController.text = newValue ?? '';  // Update controller value with the selected option
    });
  },
  decoration: InputDecoration(
    labelText: "Trạng thái",
    prefixIcon: Icon(Icons.assignment_turned_in),  // Optional: change icon to something relevant
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng chọn trạng thái';  // Validation message
    }
    return null;
  },
),


        SizedBox(height: 8),
        Text(
          'Tổng tiền: ${productDetails.isNotEmpty ? productDetails.fold(0.0, (sum, item) {
            final int quantity = item['soluong'] ?? 0;
            final double price = double.tryParse(item['giatien'].toString()) ?? 0.0;
            return sum + (quantity * price);
          }).toStringAsFixed(0) : 'N/A'} đ',
          style: TextStyle(fontSize: 20, color: Colors.blue.shade700, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
ElevatedButton(
  onPressed: () {
    // Directly use the selected status from the dropdown
    String updatedStatus = productDetails[0]['trang_thai'] ?? 'N/A'; 
    saveOrderStatus(updatedStatus); // Save using the selected dropdown value
    Get.back(result: true); // Go back after saving
  },
  child: Text('Lưu Trạng Thái'),
),

      ],
    );
  }
}
