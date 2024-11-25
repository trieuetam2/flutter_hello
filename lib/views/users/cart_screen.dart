import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/cartitem.dart';
import 'package:flutter_application_1/services/cart.dart';
import 'package:flutter_application_1/views/users/checkout_screen.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    loadCartItems();
  }

  // Load cart items from SharedPreferences
  Future<void> loadCartItems() async {
    List<CartItem> items = await SharedPreferencesCart.getCartItems();
    setState(() {
      cartItems = items;
    });
  }

  // Toggle the selected state of an item
  void toggleSelection(bool? value, int index) {
    setState(() {
      cartItems[index].selected = value ?? false;
    });
  }

  // Increase quantity
  void increaseQuantity(int index) {
    setState(() {
      if (cartItems[index].soluong < cartItems[index].maxQuantity) {
        cartItems[index].soluong++;
      }
    });
    SharedPreferencesCart.saveCartItems(cartItems); // Save to SharedPreferences
  }

  // Decrease quantity
  void decreaseQuantity(int index) {
    setState(() {
      if (cartItems[index].soluong > 1) {
        cartItems[index].soluong--;
      }
    });
    SharedPreferencesCart.saveCartItems(cartItems); // Save to SharedPreferences
  }

  // Delete selected items
  void deleteSelectedItems() async {
    setState(() {
      cartItems.removeWhere((item) => item.selected);
    });
    await SharedPreferencesCart.saveCartItems(cartItems);  // Save updated list to SharedPreferences
  }

  // Calculate the total price of selected items
  double getTotalPrice() {
    double total = 0.0;
    for (var item in cartItems) {
      if (item.selected) {
        total += item.giasp * item.soluong; // Multiply price by quantity
      }
    }
    return total;
  }

  // Check if any item is selected
  bool isAnyItemSelected() {
    return cartItems.any((item) => item.selected);
  }

  // Select or deselect all items
  void selectAll(bool? value) {
    setState(() {
      for (var item in cartItems) {
        item.selected = value ?? false;
      }
    });
  }

  String formatToVND(double value) {
  final formatter = NumberFormat.currency(
    locale: 'vi_VN',  // Vietnamese locale
    symbol: '₫',      // Vietnamese Dong symbol
    decimalDigits: 0, // Optional: set number of decimal digits
  );
  
  return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Colors.blue.shade400,
        foregroundColor: Colors.white,
        actions: [
          if (isAnyItemSelected())
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: deleteSelectedItems,
            ),
          Checkbox(
            value: cartItems.every((item) => item.selected),
            onChanged: selectAll,
          ),
        ],
      ),
      body: cartItems.isEmpty
          ? Center(child: Text('Giỏ hàng rỗng...'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartItems[index];
                return ListTile(
                  leading: Image.asset(cartItem.anhsp, width: 50, height: 50),
                  title: Text(
                    cartItem.tensp,
                    maxLines: 1,  // Limit to 2 lines
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                      'Giá: ${formatToVND(
                        cartItem.giasp is int
                            ? cartItem.giasp.toDouble()  // If it's an int, convert it to double
                            : double.parse(cartItem.giasp.toString())  // If it's a string, parse it
                      )}',
                    ),
                      Text('Số lượng: ${cartItem.soluong}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () => decreaseQuantity(index),
                      ),
                      Text(cartItem.soluong.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => increaseQuantity(index),
                      ),
                      Checkbox(
                        value: cartItem.selected,
                        onChanged: (value) => toggleSelection(value, index),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      double total = getTotalPrice();
                      if (total > 0) {
                            // Navigate to the checkout screen with the cart items
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutScreen(cartItems: cartItems),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please select items to checkout')),
                            );
                          }
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Text(
                        'Thanh toán - Tổng tiền: ${formatToVND(getTotalPrice())}',
                        
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade400,
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
