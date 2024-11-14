import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/admin/add_product_screen.dart';
import 'package:get/get.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Manager Product",
            style: TextStyle(color: Colors.white),
            ),
            IconButton(
              color: Colors.white,
              icon: Icon(Icons.add),
              onPressed: () {
                Get.to(() => AddProductScreen());
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text("ProductScreen"),
      ),
    );
  }
}
