import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/users/HomeScreenController.dart';
import 'package:flutter_application_1/services/api_connection.dart';
import 'package:flutter_application_1/views/admin/add_category_screen.dart';
import 'package:flutter_application_1/views/admin/add_product_screen.dart';
import 'package:flutter_application_1/views/admin/edit_category_screen.dart';
import 'package:flutter_application_1/views/admin/edit_product_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  //goi controller lay fetch category

  // List to hold product data
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategory(); 
    // Fetch products when the screen is initialized

  }

Future<void> fetchCategory() async {
  try {
    // Send a request to fetch category data from the server
    final response = await http.get(Uri.parse(API.showCategory));

    if (response.statusCode == 200) {
      // Parse the response data
      final data = json.decode(response.body);

      // Check if categories are returned
      if (data['showCategory'] == true) {
        setState(() {
          // Update the categories list
          categories = List<Map<String, dynamic>>.from(data['categories'].map((category) {
            return {
              "id_danhmuc": category['id_danhmuc'].toString(),
              "ten_danhmuc": category['ten_danhmuc'],
              "anh_danhmuc": category['anh_danhmuc'], // Handle null image data
            };
          }));
        });
      } else {
        setState(() {
          categories = [];
        });
        Fluttertoast.showToast(msg: 'No categories found');
      }
    } else {
      // Handle error response from server
      Fluttertoast.showToast(msg: 'Failed to load categories');
    }
  } catch (e) {
    // Handle error during the network call
    print('Error: $e');
    Fluttertoast.showToast(msg: 'Error occurred while fetching categories');
  }
}

  Future<void> deleteCategory(String productId) async {
  // Thực hiện gọi API xóa sản phẩm
  final response = await http.post(
    Uri.parse(API.deleteCategory),
    body: {
      'id_danhmuc': productId,
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (jsonResponse['deleteCategory'] == true) {
      // Nếu xóa thành công, reload lại danh sách sản phẩm
      fetchCategory();
    } else {
      print('Failed to delete category');
    }
  } else {
    print('Failed to delete category: ${response.statusCode}');
  }
}

void showDeleteDialog(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this category?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteCategory(productId); // Xóa sản phẩm
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

void filterCategory(String query) async {
  // If the query is empty, just fetch all products
  if (query.isEmpty) {
    fetchCategory();
    return;
  }

  try {
    // Send search query to the server
    final response = await http.post(
      Uri.parse(API.searchCategory),
      body: {'searchQuery': query},  // Sending search query to the backend
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Check if products are returned
      if (data['searchCategory'] == true) {
        setState(() {
        categories = List<Map<String, dynamic>>.from(data['products'].map((product) {
            // Ensure each field is correctly typed
            return {
            "id_danhmuc": product['id_danhmuc'].toString(),
            "ten_danhmuc": product['ten_danhmuc'],
            "anh_danhmuc": product['anh_danhmuc'],
            };
          }));
        });
      } else {
        // Handle case where no products are found
        setState(() {
          categories = [];
          fetchCategory();
        });
      }
    } else {
      // Handle error response
      print('Failed to load category');
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
        title: Text("Quản lý danh mục"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              // Navigate to AddProductScreen and wait for the result
              final result = await Get.to(() => AddCategoryScreen());

              // If result is true, refresh the product list
              if (result != null && result) {
                 fetchCategory();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Tìm kiếm danh mục',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                filterCategory(query); 
              },
            ),
          ),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: categories.isEmpty
                    ? Container() // No loading spinner or message, just an empty body when products are not fetched
                    : ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          var product = categories[index];

                          return Card(
                            child: ListTile(
                              leading: Image.asset(
                                // Kiểm tra nếu đường dẫn hợp lệ, nếu không sử dụng hình ảnh mặc định
                                (product["anh_danhmuc"] != null && product["anh_danhmuc"].isNotEmpty)
                                    ? product["anh_danhmuc"]  // Nếu có đường dẫn hợp lệ
                                    : 'assets/img/pig.png',  // Nếu không, sử dụng hình ảnh mặc định
                                width: 50,  // Bạn có thể thay đổi kích thước của ảnh nếu cần
                                height: 50,
                                fit: BoxFit.cover,  // Điều chỉnh cách hiển thị hình ảnh
                              ),
                              title: Text(product['ten_danhmuc']),
                              subtitle: Text('ID: ${product['id_danhmuc']}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditCategoryScreen(
                                            productId: product['id_danhmuc'],
                                          ),
                                        ),
                                      );
                                      if (result != null && result) {
                                        fetchCategory(); // Refresh products after update
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () {
                                      // Hiển thị hộp thoại xác nhận xóa
                                      showDeleteDialog(context, product['id_danhmuc']);
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
