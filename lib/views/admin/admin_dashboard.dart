import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_connection.dart';
import 'package:flutter_application_1/services/userInfoRemember.dart';
import 'package:flutter_application_1/views/admin/category_screen.dart';
import 'package:flutter_application_1/views/admin/order_screen.dart';
import 'package:flutter_application_1/views/admin/product_screen.dart';
import 'package:flutter_application_1/views/admin/user_screen.dart';
import 'package:flutter_application_1/views/users/login_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AdminDashboard extends StatelessWidget {
  final CurrentUSerAdmin _currentUserAdmin = Get.put(CurrentUSerAdmin());

  Future<Map<String, dynamic>> getDashboardCounts() async {
    final url = Uri.parse(API.overViewDashboard); // Replace with your actual API URL

    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON data.
      return jsonDecode(response.body);
    } else {
      // If the server does not return a 200 OK response, throw an error.
      throw Exception('Failed to load dashboard counts');
    }
  }

  @override
  Widget build(BuildContext context) {
    _currentUserAdmin.getUserInfoAdmin();

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      drawer: AdminDrawer(), // Navigation Drawer
      body: SafeArea( // Ensure content is within screen bounds
        child: FutureBuilder<Map<String, dynamic>>(
          future: getDashboardCounts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final data = snapshot.data!;
              
              return SingleChildScrollView( // Allow scrolling if content overflows vertically
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overview Section (Cards)
                    Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Cards Section (Users, Orders, Revenue)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DashboardCard(
                          title: 'Users',
                          value: data['user_count'].toString(),
                          color: Colors.blue,
                          onTap: () {
                            Get.to(() => UserScreen());
                          },
                        ),
                        DashboardCard(
                          title: 'Orders',
                          value: data['order_count'].toString(),
                          color: Colors.green,
                          onTap: () {
                            Get.to(() => ProductScreen());
                          },
                        ),
                        DashboardCard(
                          title: 'Total Revenue',
                          value: '\$${data['total_revenue']}',
                          color: Colors.orange,
                          onTap: () {
                            Get.to(() => CategoryScreen());
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Stats Section (Buttons for Actions)
                    Text(
                      'Quản lý',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Action Buttons (Manage Users, Manage Products, View Reports)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          flex: 1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0)), // Remove padding inside the button
                            onPressed: () {
                              if (_currentUserAdmin.user.id_role == 3) {
                                Fluttertoast.showToast(msg: 'Bạn không có quyền truy cập');
                              } else {
                                Get.to(() => UserScreen());
                              }
                            },
                            child: Text(
                              'Users',
                              style: TextStyle(fontSize: 15), // Smaller font size
                              overflow: TextOverflow.ellipsis, // Ensure text doesn't overflow
                              maxLines: 1, // Keep text on one line
                            ),
                          ),
                        ),
                        SizedBox(width: 5), // Adjust spacing between buttons
                        Flexible(
                          flex: 1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0)), // Remove padding inside the button
                            onPressed: () {
                              Get.to(() => ProductScreen());
                            },
                            child: Text(
                              'Products',
                              style: TextStyle(fontSize: 15), // Smaller font size
                              overflow: TextOverflow.ellipsis, // Ensure text doesn't overflow
                              maxLines: 1, // Keep text on one line
                            ),
                          ),
                        ),
                        SizedBox(width: 5), // Adjust spacing between buttons
                        Flexible(
                          flex: 1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0)), // Remove padding inside the button
                            onPressed: () {
                              Get.to(() => CategoryScreen());
                            },
                            child: Text(
                              'Category',
                              style: TextStyle(fontSize: 15), // Smaller font size
                              overflow: TextOverflow.ellipsis, // Ensure text doesn't overflow
                              maxLines: 1, // Keep text on one line
                            ),
                          ),
                        ),
                        SizedBox(width: 5), // Adjust spacing between buttons
                        Flexible(
                          flex: 1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0)), // Remove padding inside the button
                            onPressed: () {
                              Get.to(() => OrderScreen());
                            },
                            child: Text(
                              'Orders',
                              style: TextStyle(fontSize: 15), // Smaller font size
                              overflow: TextOverflow.ellipsis, // Ensure text doesn't overflow
                              maxLines: 1, // Keep text on one line
                            ),
                          ),
                        ),
                        SizedBox(width: 5), // Adjust spacing between buttons
                        Flexible(
                          flex: 1,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0)), // Remove padding inside the button
                            onPressed: () {
                              print('Reports');
                            },
                            child: Text(
                              'Reports',
                              style: TextStyle(fontSize: 15), // Smaller font size
                              overflow: TextOverflow.ellipsis, // Ensure text doesn't overflow
                              maxLines: 1, // Keep text on one line
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}

// Dashboard card widget for quick stats (Users, Orders, Revenue)
class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final VoidCallback onTap;

  DashboardCard({
    required this.title,
    required this.value,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Admin Drawer for navigation
class AdminDrawer extends StatelessWidget {
  final CurrentUSerAdmin _currentUserAdmin = Get.put(CurrentUSerAdmin());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.blue),
                ),
                SizedBox(height: 10),
                Text(
                  _currentUserAdmin.user.user_name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  _currentUserAdmin.user.user_email,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => AdminDashboard()));
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Manage Users'),
            onTap: () {
              if (_currentUserAdmin.user.id_role == 3) {
                Fluttertoast.showToast(msg: 'Bạn không có quyền truy cập');
              } else {
                Get.to(() => UserScreen());
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.store),
            title: Text('Manage Products'),
            onTap: () {
              Get.to(() => ProductScreen());
            },
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: Text('Manage Categories'),
            onTap: () {
              Get.to(() => CategoryScreen());
            },
          ),
          ListTile(
            leading: Icon(Icons.add_box),
            title: Text('Manage Orders'),
            onTap: () {
              Get.to(() => OrderScreen());
            },
          ),
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text('View Reports'),
            onTap: () {
              print('Navigate to Reports');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Userinforemember.removeUserAdmin().then((value) {
                Get.off(LoginPage());
              });
            },
          ),
        ],
      ),
    );
  }
}
