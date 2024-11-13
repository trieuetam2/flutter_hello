import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/users/authenticationController.dart';
import 'package:flutter_application_1/models/dangki.dart';
import 'package:flutter_application_1/services/api_connection.dart';
import 'package:flutter_application_1/services/userInfoRemember.dart';
import 'package:flutter_application_1/views/users/dashboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Để làm việc với JSON
import 'register_page.dart'; // Import RegisterPage nếu cần

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthenticationController _authController = Get.put(AuthenticationController());
  final _formKey = GlobalKey<FormState>();
  var isObsecure = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //container img
              Container(
                width: MediaQuery.of(context).size.width,

                height: 100,
                child: Image.asset("lib/assets/img/pig.png"),
              ),
              SizedBox(height: 20),
              // Email field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Password field
              Obx(
                () =>  TextFormField(
                controller: _passwordController,
                obscureText: isObsecure.value,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: Obx(
                    () => GestureDetector(
                      onTap: (){
                        isObsecure.value = !isObsecure.value;
                      },
                      child: Icon(
                        isObsecure.value ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                    )
                  )
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              
              ),

              SizedBox(height: 16),

              // Login button
              ElevatedButton(
                onPressed: () async{
                  if (_formKey.currentState!.validate()) { // Correct way to access validate() on FormState
                    String email = _emailController.text.trim();
                    String password = _passwordController.text.trim();
                    await _authController.loginUser(email, password);
                  }
                },
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
              SizedBox(height: 16),

              // Navigate to Register Page
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () {
                      // Navigate to the RegisterPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text('Register'),
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
