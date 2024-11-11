import 'package:flutter/material.dart';
import 'views/counter_view.dart';  // Đảm bảo bạn import đúng

class MyApp extends StatelessWidget {
  // Thêm tham số key vào constructor
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter MVC Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CounterView(),
    );
  }
}

void main() {
  runApp(const MyApp());
}
