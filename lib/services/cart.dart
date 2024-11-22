// shared_preferences_helper.dart
import 'dart:convert';
import 'package:flutter_application_1/models/cartitem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesCart {
  static const String _cartKey = 'cart_items';

  // Save cart items to SharedPreferences
  static Future<void> saveCartItems(List<CartItem> cartItems) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItemsStringList = cartItems
        .map((cartItem) => json.encode(cartItem.toMap()))
        .toList();
    prefs.setStringList(_cartKey, cartItemsStringList);
  }

  // Retrieve cart items from SharedPreferences
  static Future<List<CartItem>> getCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItemsStringList = prefs.getStringList(_cartKey) ?? [];
    return cartItemsStringList
        .map((cartItemString) =>
            CartItem.fromMap(json.decode(cartItemString)))
        .toList();
  }

  // Clear the cart from SharedPreferences
  static Future<void> clearCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_cartKey);
  }

}
