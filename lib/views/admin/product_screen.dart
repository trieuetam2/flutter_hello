import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_connection.dart';
import 'package:flutter_application_1/views/admin/add_product_screen.dart';
import 'package:flutter_application_1/views/admin/edit_product_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  // List to hold product data
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();
    // Fetch products when the screen is initialized
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse(API.showProduct));

    if (response.statusCode == 200) {
      // Parse the JSON response as a Map
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Ensure 'showProduct' is true and 'products' contains the list of products
      if (jsonResponse['showProduct'] == true && jsonResponse['products'] != null) {
        List<dynamic> productList = jsonResponse['products'];

        setState(() {
          // Convert product data into a list of maps and update state
          products = productList.map((product) {
            return {
              "id_sanpham": product['id_sanpham'],
              "tensp": product['tensp'],
              "anhsp": product['anhsp'],
              "giasp": product['giasp'],
            };
          }).toList();
        });
      }
    } else {
      print('Failed to load products: ${response.statusCode}');
    }
  }

  Future<void> deleteProduct(String productId) async {
  // Thực hiện gọi API xóa sản phẩm
  final response = await http.post(
    Uri.parse(API.deleteProduct),
    body: {
      'id_sanpham': productId,
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (jsonResponse['deleteProduct'] == true) {
      // Nếu xóa thành công, reload lại danh sách sản phẩm
      fetchProducts();
    } else {
      print('Failed to delete product');
    }
  } else {
    print('Failed to delete product: ${response.statusCode}');
  }
}

  Future<void> fetchProductDetails(String productId) async {
      final response = await http.post(
        Uri.parse(API.deleteProduct),
        body: {
          'id_sanpham': productId,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['showEditProduct'] == true && jsonResponse['product'] != null) {
          setState(() {
            productId = jsonResponse['product'];
          });
        } else {
          print('Failed to fetch product details');
        }
      } else {
        print('Failed to fetch product details: ${response.statusCode}');
      }
    }

void showDeleteDialog(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteProduct(productId); // Xóa sản phẩm
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

void filterProducts(String query) async {
  // If the query is empty, just fetch all products
  if (query.isEmpty) {
    fetchProducts();  // Fetch all products without filter
    return;
  }

  try {
    // Send search query to the server
    final response = await http.post(
      Uri.parse(API.searchProduct),
      body: {'searchQuery': query},  // Sending search query to the backend
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Check if products are returned
      if (data['searchProduct'] == true) {
        setState(() {
          products = List<Map<String, dynamic>>.from(data['products']);
          //Fluttertoast.showToast(msg: 'tim kiem thanh cong');
        });
      } else {
        // Handle case where no products are found
        setState(() {
          products = [];
          fetchProducts(); 
        });
      }
    } else {
      // Handle error response
      print('Failed to load products');
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
        title: Text("Manager Product"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              // Navigate to AddProductScreen and wait for the result
              final result = await Get.to(() => AddProductScreen());

              // If result is true, refresh the product list
              if (result != null && result) {
                fetchProducts(); // Call fetchProducts to refresh the list
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
                labelText: 'Search Product',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                filterProducts(query); 
              },
            ),
          ),
          
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: products.isEmpty
                    ? Container() // No loading spinner or message, just an empty body when products are not fetched
                    : ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          var product = products[index];

                          return Card(
                            child: ListTile(
                              leading: Image.asset(
                                // Kiểm tra nếu đường dẫn hợp lệ, nếu không sử dụng hình ảnh mặc định
                                (product["anhsp"] != null && product["anhsp"].isNotEmpty)
                                    ? product["anhsp"]  // Nếu có đường dẫn hợp lệ
                                    : 'assets/img/pig.png',  // Nếu không, sử dụng hình ảnh mặc định
                                width: 50,  // Bạn có thể thay đổi kích thước của ảnh nếu cần
                                height: 50,
                                fit: BoxFit.cover,  // Điều chỉnh cách hiển thị hình ảnh
                              ),
                              title: Text(product['tensp']),
                              subtitle: Text('Price: ${product['giasp']} VND'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditProductScreen(
                                            productId: product['id_sanpham'],
                                          ),
                                        ),
                                      );
                                      if (result != null && result) {
                                        fetchProducts(); // Refresh products after update
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () {
                                      // Hiển thị hộp thoại xác nhận xóa
                                      showDeleteDialog(context, product['id_sanpham']);
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
