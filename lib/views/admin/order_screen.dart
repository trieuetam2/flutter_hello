import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_connection.dart';
import 'package:flutter_application_1/views/admin/detailorders_manage_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  // List to hold product data
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      // Send a request to fetch category data from the server
      final response = await http.get(Uri.parse(API.showOrderManage));

      if (response.statusCode == 200) {
        // Parse the response data
        final data = json.decode(response.body);

        // Check if orders are returned
        if (data['showOrderManage'] == true) {
          setState(() {
            // Update the orders list
            orders = List<Map<String, dynamic>>.from(data['ordermanages'].map((order) {
              return {
                "id_dathang": order['id_dathang'].toString(),  // Ensure this is being correctly parsed
                "madathang": order['madathang'],  // Correct key for order ID
                "trangthai": order['trangthai'],
                "tongtien": order['tongtien'].toString(),
              };
            }));
          });
        } else {
          setState(() {
            orders = [];
          });
          Fluttertoast.showToast(msg: 'No orders found');
        }
      } else {
        // Handle error response from server
        Fluttertoast.showToast(msg: 'Failed to load orders');
      }
    } catch (e) {
      // Handle error during the network call
      print('Error: $e');
      Fluttertoast.showToast(msg: 'Error occurred while fetching orders');
    }
  }

  Color _getStatusColor(String trangthai) {
    switch (trangthai) {
      case 'Chờ xác nhận':
        return Colors.blue;
      case 'Chờ giao hàng':
        return Colors.orange;
      case 'Đang giao hàng':
      case 'Giao thành công':
        return Colors.green;
      default:
        return Colors.grey; // Default color if the status doesn't match any
    }
  }

  void filterOrder(String query) async {
    // If the query is empty, just fetch all products
    if (query.isEmpty) {
      fetchOrders();
      return;
    }

    try {
      // Send search query to the server
      final response = await http.post(
        Uri.parse(API.searchOrder),
        body: {'searchQuery': query},  // Sending search query to the backend
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if products are returned
        if (data['searchOrder'] == true) {
          setState(() {
            orders = List<Map<String, dynamic>>.from(data['products'].map((order) {
              // Ensure each field is correctly typed
              return {
                "id_dathang": order['id_dathang'].toString(),  // Ensure this is being correctly parsed
                "madathang": order['madathang'],  // Correct key for order ID
                "trangthai": order['trangthai'],
                "tongtien": order['tongtien'].toString(),
              };
            }));
          });
        } else {
          // Handle case where no products are found
          setState(() {
            orders = [];
            fetchOrders();
          });
        }
      } else {
        // Handle error response
        print('Failed to load order');
        Fluttertoast.showToast(msg: 'tim kiem that bai');
      }
    } catch (e) {
      // Handle network error
      print('Error: $e');
      Fluttertoast.showToast(msg: 'tim kiem error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Always return a Widget, even if the orders are empty or there's an issue.
    if (orders.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Quản lý đơn hàng"),
        ),
        body: Center(
          child: CircularProgressIndicator(), // Show loading indicator if orders are empty
        ),
      );
    }

    // Return a ListView once data is available
    return Scaffold(
      appBar: AppBar(
        title: Text("Quản lý đơn hàng"),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Tìm kiếm mã đơn hàng',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                filterOrder(query);
              },
            ),
          ),

          // ListView.builder for orders
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    elevation: 4.0, // Adding shadow effect to the card
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners for the card
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      leading: Icon(Icons.shopping_cart, color: Colors.blue.shade400, size: 40),
                      title: Text(
                        'Order #${order['madathang']}',  // Using madathang (order ID)
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Trạng thái: '),
                              Text(
                                '${order['trangthai']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: _getStatusColor(order['trangthai']),
                                ),
                              ),
                            ],
                          ),
                          Text('Thành tiền: ${order['tongtien']} VND', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 20, color: Colors.blue.shade400),
                      onTap: () async {
                        // Navigate to detail screen passing the correct `madathang` as order ID
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              print(order['id_dathang']);  // This will print the order ID
                              // Pass madathang to the detail screen
                              return DetailordersManageScreen(
                                productId: order['id_dathang'].toString(),
                              );
                            },
                          ),
                        );

                        if (result != null && result) {
                          fetchOrders(); // Call fetchOrders to refresh the list
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
