import 'package:flutter/material.dart';
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
  final _formKey = GlobalKey<FormState>();
  var isObsecure = true.obs;

  _login() async {
    try {
    var res = await http.post(
        Uri.parse(API.logIn),
        body: {
          "user_email": _emailController.text.trim(),
          "user_password": _passwordController.text.trim(),
        }
      );

    if (res.statusCode == 200) {
        var resbodyLogin = jsonDecode(res.body);
        if(resbodyLogin['successLogin'] == true){
          Fluttertoast.showToast(msg: 'dang nhap thanh cong');
          

          //save unserinfoRemember to local store prefence
          Dangki userInfo = Dangki.fromJson(resbodyLogin['userData']);

          await Userinforemember.saveRememberUser(userInfo);
      
          //chuyen huong den dashboard
          Future.delayed(Duration(milliseconds: 2000), (){
                  Get.to(() => Dashboard());
                });
          
        }else{
          Fluttertoast.showToast(msg: 'sai tên tài khoản mật khẩu');
        }
    } else {
      throw Exception('Failed to sign up');
    }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      print(e.toString());
    }
}

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
                onPressed: (){
                if (_formKey.currentState!.validate()) { // Correct way to access validate() on FormState
                  _login();
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
