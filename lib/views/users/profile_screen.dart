import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/userInfoRemember.dart';
import 'package:flutter_application_1/views/users/login_page.dart';
import 'package:get/get.dart';
class ProfileScreen extends StatelessWidget {
  final CurrentUSer _currentUser = Get.put(CurrentUSer());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Implement your sign-out logic here
              print("Sign out");
            },
          ),
        ],
      ),
      body: Center( // Center the entire content vertically
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Center the content vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Center the content horizontally
            children: [
              // User Avatar
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: Text(
                  "", // Display first letter of the name as avatar
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),

              // Name with Icon
              Row(
              mainAxisSize: MainAxisSize.min,  // Keeps the row as small as possible
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns the content to the start of the row
              children: <Widget>[
                Icon(Icons.person, color: Colors.blue),  // User Icon
                SizedBox(width: 10),  // Space between icon and text
                Text(
                  _currentUser.user.user_name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

              SizedBox(height: 15), // Space between name and email

              // Email with Icon
              Row(
                mainAxisSize: MainAxisSize.min, // Keeps the row as small as possible
                children: [
                  Icon(Icons.email, color: Colors.blue), // Email Icon
                  SizedBox(width: 10), // Space between icon and text
                  Text(
                    _currentUser.user.user_email,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30), // Space before the sign-out button

              // Sign Out Button
              ElevatedButton(
                onPressed: () {
                 Userinforemember.removeUser().then((value) {
                  Get.off(LoginPage());
                });
                },
                child: Text(
                  "Sign Out",
                  style: TextStyle(
                    color: Colors.white, // Set the text color to white
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  backgroundColor: Colors.red, // Button color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
