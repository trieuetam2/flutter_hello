import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_connection.dart';
import 'package:flutter_application_1/services/userInfoRemember.dart';
import 'package:flutter_application_1/models/dathang.dart';
import 'package:flutter_application_1/views/users/detail_order_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final CurrentUSer _currentUser = Get.put(CurrentUSer());
  List<Dathang> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders(); // Fetch orders when the screen is initialized
  }

  // Function to fetch orders from the API
  Future<void> fetchOrders() async {
    final response = await http.get(
      Uri.parse('${API.showOrderByID}?user_id=${_currentUser.user.user_id}')
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['showOrderByID'] == true) {
        List<dynamic> orderList = data['productss'];
        setState(() {
          orders = orderList.map((order) => Dathang.fromJson(order)).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No orders found'))
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load orders'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: orders.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading indicator if orders are empty
          : ListView.builder(
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
                        'Order #${order.madathang}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Trạng thái: ${order.trangthai}', style: TextStyle(fontSize: 14)),
                          Text('Thành tiền: ${order.tongtien} VND', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 20, color: Colors.blue.shade400),
                      onTap: () async {
                        // Navigate to detail screen passing the correct `id_dathang`
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              print(order.id_dathang);  // This will print the order ID
                              return DetailOrderScreen(
                                productId: order.id_dathang.toString(),  // Pass productId as a named argument
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
