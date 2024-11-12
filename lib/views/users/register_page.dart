import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/users/authenticationController.dart';
import 'package:flutter_application_1/models/dangki.dart';
import 'package:flutter_application_1/services/api_connection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var isObsecure = true.obs;

  final AuthenticationController _authController = Get.put(AuthenticationController());

  // Register function
  void _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      String email = _emailController.text.trim();

      // Check if email is already registered
      bool emailExists = await _authController.checkEmailExists(email);

      if (emailExists) {
        Fluttertoast.showToast(msg: 'Email đã được đăng kí, hãy chọn email khác!');
      } else {
        // Proceed with registration if email does not exist
        Dangki userModel = Dangki(
          1,
          _nameController.text.trim(),
          email,
          _passwordController.text.trim(),
        );

        bool registrationSuccess = await _authController.registerUser(userModel);

        if (registrationSuccess) {
          Fluttertoast.showToast(msg: 'Đăng kí thành công');
        } else {
          Fluttertoast.showToast(msg: 'Đăng kí thất bại');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // name field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.edit),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Email field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
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

              // Register button
              ElevatedButton(
                onPressed: _register,
                child: Text('Register'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
              SizedBox(height: 16),

              // Navigate back to Login Page
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?'),
                  TextButton(
                    onPressed: () {
                      // Navigate back to the LoginPage
                      Navigator.pop(context);
                    },
                    child: Text('Login'),
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
