import 'dart:convert';
import 'package:flutter_application_1/models/dangki.dart';
import 'package:flutter_application_1/services/api_connection.dart';
import 'package:flutter_application_1/services/jwt_save_get.dart';
import 'package:flutter_application_1/views/admin/admin_dashboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/services/userInfoRemember.dart';
import 'package:flutter_application_1/views/users/dashboard.dart';

class AuthenticationController extends GetxController {
  // Validation function for checking if email is already taken
  Future<bool> checkEmailExists(String email) async {
    try {
      var res = await http.post(
        Uri.parse(API.validateEmail),
        body: {'user_email': email},
      );

      if (res.statusCode == 200) {
        var resbody = jsonDecode(res.body);
        return resbody['emailValidate'] == true;
      } else {
        throw Exception('Failed to check email');
      }
    } catch (e) {
      print('Error checking email: $e');
      Fluttertoast.showToast(msg: 'Error checking email: $e');
      return false;
    }
  }

  // Function to register a new user
  Future<bool> registerUser(Dangki user) async {
    try {
      var res = await http.post(
        Uri.parse(API.signUp),
        body: user.toJson(),
      );

      if (res.statusCode == 200) {
        var resbodySignup = jsonDecode(res.body);
        return resbodySignup['successSignUp'] == true;
      } else {
        throw Exception('Failed to sign up');
      }
    } catch (e) {
      print('Error registering user: $e');
      Fluttertoast.showToast(msg: 'Error registering user: $e');
      return false;
    }
  }

  //function logic login and save to local store
Future<bool> loginUser(String email, String password) async {
  try {
    var res = await http.post(
      Uri.parse(API.logIn),
      body: {
        "user_email": email.trim(),
        "user_password": password.trim(),
      },
    );

    if (res.statusCode == 200) {
      var resbodyLogin = jsonDecode(res.body);

      if (resbodyLogin['successLogin'] == true) {
        Dangki userInfo = Dangki.fromJson(resbodyLogin['userData']);
        
        if (resbodyLogin['jwt'] != null) {
          // Save JWT to SharedPreferences
          await saveJWT(resbodyLogin['jwt']);
        }

        print("token: " + resbodyLogin['jwt']);

        // Handle other user checks (locked account, role, etc.)
        if (userInfo.status == 2) {
          Fluttertoast.showToast(msg: 'Tài khoản của bạn đã bị khóa');
          return false;
        } else {
          if (userInfo.id_role == 1 || userInfo.id_role == 3) {
            await Userinforemember.saveRememberUserAdmin(userInfo);
            Future.delayed(Duration(milliseconds: 2000), () {
              Fluttertoast.showToast(msg: 'Đăng nhập thành công admin');
              Get.to(() => AdminDashboard());
            });
          } else {
            await Userinforemember.saveRememberUser(userInfo);
            Fluttertoast.showToast(msg: 'Đăng nhập thành công');
            Future.delayed(Duration(milliseconds: 2000), () {
              Get.to(() => Dashboard());
            });
          }
          return true; // Login successful
        }
      } else {
        Fluttertoast.showToast(msg: 'Sai tên tài khoản hoặc mật khẩu');
        return false; // Invalid credentials
      }
    } else {
      throw Exception('Failed to login');
    }
  } catch (e) {
    print('Error during login: $e');
    Fluttertoast.showToast(msg: e.toString());
    return false;
  }
}


}
