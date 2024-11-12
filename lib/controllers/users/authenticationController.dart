import 'dart:convert';
import 'package:flutter_application_1/models/dangki.dart';
import 'package:flutter_application_1/services/api_connection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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
}
