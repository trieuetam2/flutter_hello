
import 'dart:convert';

import 'package:flutter_application_1/services/api_connection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/sanpham.dart';

class Addproductcontroller {
  Future<bool> addProducts(Sanpham sanpham) async {
    try {
      var res = await http.post(
        Uri.parse(API.addProduct),
        body: sanpham.toJson(),
      );

      if (res.statusCode == 200) {
        var resbodySignup = jsonDecode(res.body);
        return resbodySignup['successAddProduct'] == true;
      } else {
        throw Exception('Failed to sign up');
      }
    } catch (e) {
      print('Error registering sanpham: $e');
      Fluttertoast.showToast(msg: 'Error registering sanpham: $e');
      return false;
    }
  }
}
