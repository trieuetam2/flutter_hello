import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/admin/product_screen.dart';
import 'package:flutter_application_1/views/users/login_page.dart';
import 'package:get/get.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      drawer: AdminDrawer(), // Navigation Drawer
      body: SafeArea( // Ensure content is within screen bounds
        child: SingleChildScrollView( // Allow scrolling if content overflows vertically
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
                  // Wrap each card with Expanded to avoid overflow
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0), // Reduce padding if necessary
                      child: DashboardCard(
                        title: 'Users',
                        value: '1200',
                        color: Colors.blue,
                        onTap: () {
                          print('Navigate to Users');
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0), // Add left padding for spacing
                      child: DashboardCard(
                        title: 'Orders',
                        value: '450',
                        color: Colors.green,
                        onTap: () {
                          print('Navigate to Orders');
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0), // Add left padding for spacing
                      child: DashboardCard(
                        title: 'Revenue',
                        value: '\$45,000',
                        color: Colors.orange,
                        onTap: () {
                          print('Navigate to Revenue');
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Stats Section (Buttons for Actions)
              Text(
                'Actions',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),

              // Action Buttons (Manage Users, Manage Products, View Reports)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        print('Manage Users');
                      },
                      child: Text('Manage Users'),
                    ),
                  ),
                  SizedBox(width: 10), // Adjust spacing between buttons
                  Flexible(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        print('Manage Products');
                      },
                      child: Text('Manage Products'),
                    ),
                  ),
                  SizedBox(width: 10), // Adjust spacing between buttons
                  Flexible(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        print('View Reports');
                      },
                      child: Text('View Reports'),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
                  'Admin Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'admin@example.com',
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
              print('Navigate to Manage Users');
            },
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: Text('Manage Products'),
            onTap: () {
              Get.to(() => ProductScreen());
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
              Get.off(LoginPage());
            },
          ),
        ],
      ),
    );
  }
}
