
import 'dart:convert';

import 'package:flutter_application_1/models/chitiet_donhang.dart';
import 'package:flutter_application_1/models/dathang.dart';
import 'package:flutter_application_1/services/api_connection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/models/sanpham.dart';

class Saveordercontroller extends GetxController {
  Future<bool> saveOrder(Dathang order, List<ChitietDonhang> orderDetails) async {
    try {
      var response = await http.post(
        Uri.parse(API.saveOrder),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'madathang': order.madathang,
          'makh': order.makh,
          'trangthai': order.trangthai,
          'tongtien': order.tongtien,
          'ngaydathang': order.ngaydathang.toIso8601String(),
          'giaohang': order.giaohang,
          'id_kh': order.id_kh,
          'chitiet': orderDetails.map((item) => item.toJson()).toList(),
        }),
      );

      if (response.statusCode == 200) {
        var resBody = jsonDecode(response.body);
        return resBody['successAddOrder'] == true;
      } else {
        throw Exception('Failed to place order');
      }
    } catch (e) {
      print("Error placing order: $e");
      return false;
    }
  }
}

