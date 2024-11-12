import 'dart:io';  // Import the required library for HttpOverrides
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/users/login_page.dart';  

void main() {
  // Disable SSL validation
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter MVC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: Future.delayed(Duration(seconds: 2)),  // Add a future
        builder: (context, dataSnapShot) {
          return LoginPage(); 
        },
      ),
    );
  }
}

// Define MyHttpOverrides class to override the HttpClient and disable SSL verification
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    if (Platform.isAndroid) {
      // Allow self-signed certificates for Android
      return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    }

    // Allow self-signed certificates for other platforms (e.g., iOS, Web)
    return super.createHttpClient(context)
      ..findProxy = (uri) {
        return "PROXY localhost:80"; // Example proxy setting (you can remove if not needed)
      }
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
