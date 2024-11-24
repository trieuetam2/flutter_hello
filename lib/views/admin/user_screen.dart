import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/users/HomeScreenController.dart';
import 'package:flutter_application_1/services/api_connection.dart';
import 'package:flutter_application_1/views/admin/add_category_screen.dart';
import 'package:flutter_application_1/views/admin/add_product_screen.dart';
import 'package:flutter_application_1/views/admin/edit_category_screen.dart';
import 'package:flutter_application_1/views/admin/edit_product_screen.dart';
import 'package:flutter_application_1/views/admin/edit_user_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {

  //goi controller lay fetch category

  // List to hold product data
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    fetchUser(); 
    // Fetch products when the screen is initialized

  }

Future<void> fetchUser() async {
  try {
    // Send a request to fetch category data from the server
    final response = await http.get(Uri.parse(API.showUser));

    if (response.statusCode == 200) {
      // Parse the response data
      final data = json.decode(response.body);

      // Check if users are returned
      if (data['showUser'] == true) {
        setState(() {
          // Update the users list
          users = List<Map<String, dynamic>>.from(data['users'].map((product) {
            return {
              "user_id": product['user_id'],
              "user_name": product['user_name'],
              "user_email": product['user_email'],
              "id_phanquyen": product['id_phanquyen'],
              "trangthai": product['trangthai'],
            };
          }));
        });
      } else {
        setState(() {
          users = [];
        });
        Fluttertoast.showToast(msg: 'No users found');
      }
    } else {
      // Handle error response from server
      Fluttertoast.showToast(msg: 'Failed to load users');
    }
  } catch (e) {
    // Handle error during the network call
    print('Error: $e');
    Fluttertoast.showToast(msg: 'Error occurred while fetching users');
  }
}

void filterUser(String query) async {
  // If the query is empty, just fetch all products
  if (query.isEmpty) {
    fetchUser();
    return;
  }

  try {
    // Send search query to the server
    final response = await http.post(
      Uri.parse(API.searchUser),
      body: {'searchQuery': query},  // Sending search query to the backend
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Check if products are returned
      if (data['searchUser'] == true) {
        setState(() {
        users = List<Map<String, dynamic>>.from(data['products'].map((user) {
            // Ensure each field is correctly typed
            return {
              "user_id": user['user_id'].toString(),
              "user_name": user['user_name'],
              "user_email": user['user_email'],
              "id_phanquyen": user['id_phanquyen'].toString(),
            };
          }));
        });
      } else {
        // Handle case where no products are found
        setState(() {
          users = [];
          fetchUser();
        });
      }
    } else {
      // Handle error response
      print('Failed to load user');
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
  return Scaffold(
    appBar: AppBar(
      title: Text("Quản lý user"),
      actions: [],
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Tìm kiếm user',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (query) {
              filterUser(query); 
            },
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: users.isEmpty
                ? Container() // If no users, show an empty container
                : ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      var user = users[index];

                      return Card(
                        child: ListTile(
                          title: Text(user['user_name']),
                          subtitle: Text('Email: ${user['user_email']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[

                            user['trangthai'] == '2'
                            ?  IconButton(
                                icon: Icon(Icons.lock),
                                color: Colors.red, // Lock icon in red
                                onPressed: () {
                                  Fluttertoast.showToast(msg: 'User is locked');
                                },
                              )
                            : Container(), 

                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditUserScreen(
                                        productId: user['user_id'],
                                      ),
                                    ),
                                  );
                                  if (result != null && result) {
                                    fetchUser(); 
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    ),
  );
}

  
}
