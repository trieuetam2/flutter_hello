import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_connection.dart';
import 'package:flutter_application_1/services/userInfoRemember.dart';
import 'package:flutter_application_1/views/admin/category_screen.dart';
import 'package:flutter_application_1/views/admin/product_screen.dart';
import 'package:flutter_application_1/views/admin/user_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ViewReportsScreen extends StatefulWidget {
  @override
  _ViewReportsScreenState createState() => _ViewReportsScreenState();
}

class _ViewReportsScreenState extends State<ViewReportsScreen> {

  final CurrentUSerAdmin _currentUserAdmin = Get.put(CurrentUSerAdmin());

  double totalRevenue = 0;
  int totalProductsSold = 0;
  int totalCustomers = 0;

  @override
  void initState() {
    super.initState();
    fetchRevenueData();
  }

  Future<void> fetchRevenueData() async {
    try {
      final response = await http.get(Uri.parse(API.viewDoanhThuNgay));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'success') {
          setState(() {
            // Parse values and check for errors
            totalRevenue = double.tryParse(data['total_revenue']) ?? 0.0; // Fallback to 0.0 if parse fails
            totalProductsSold = int.tryParse(data['total_products_sold']) ?? 0; // Fallback to 0 if parse fails
            totalCustomers = data['total_customers'] ?? 0; // If this is null, fallback to 0
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'] ?? 'No data available')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unable to load data.')));
      }
    } catch (e) {
      // Catch any error that occurs (network error, json decoding, etc.)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error parsing data: $e')));
    }
  }

Future<Map<String, dynamic>> getDashboardCounts() async {
  final url = Uri.parse(API.overViewDashboard); // Replace with your actual API URL

  final response = await http.get(url);

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, parse the JSON data.
    Map<String, dynamic> data = jsonDecode(response.body);

    // Check if 'total_revenue' exists and is a String, then convert to double
    if (data.containsKey('total_revenue')) {
      String totalRevenueStr = data['total_revenue'];
      try {
        // Convert the 'total_revenue' string to double
        data['total_revenue'] = double.parse(totalRevenueStr);
      } catch (e) {
        // If parsing fails, you can handle the error as needed
        print('Error parsing total_revenue to double: $e');
        data['total_revenue'] = 0.0; // Default value in case of error
      }
    }

    return data;
  } else {
    // If the server does not return a 200 OK response, throw an error.
    throw Exception('Failed to load dashboard counts');
  }
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
    _currentUserAdmin.getUserInfoAdmin();

    return Scaffold(
      appBar: AppBar(
        title: Text('View Reports'),
      ),
      body: SafeArea( // Ensure content is within screen bounds
        child: FutureBuilder<Map<String, dynamic>>(
          future: getDashboardCounts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final data = snapshot.data!;

              return SingleChildScrollView( // Allow scrolling if content overflows vertically
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overview Section (Cards)
                    Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Cards Section (Users, Orders, Revenue)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DashboardCard(
                          title: 'Users',
                          value: data['user_count'].toString(),
                          color: Colors.blue,
                          onTap: () {
                            Get.to(() => UserScreen());
                          },
                          animateValue: data['user_count'], // Thêm giá trị cần tăng dần vào đây
                        ),
                        DashboardCard(
                          title: 'Orders',
                          value: data['order_count'].toString(),
                          color: Colors.green,
                          onTap: () {
                            Get.to(() => ProductScreen());
                          },
                          animateValue: data['order_count'], // Thêm giá trị cần tăng dần vào đây
                        ),
                        DashboardCard(
                          title: 'Ước tính',
                          value: formatToVND(data['total_revenue']),
                          color: Colors.orange,
                          onTap: () {
                            Get.to(() => CategoryScreen());
                          },
                          animateValue: data['total_revenue'], // Thêm giá trị cần tăng dần vào đây
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Pie Chart Section
                    Text(
                      'Hôm nay',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),

                    Text('Tổng doanh thu: ${formatToVND(totalRevenue)}', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 10),
                    Text('Số lượng sản phẩm bán: $totalProductsSold', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 10),
                    Text('Số lượng khách hàng: $totalCustomers', style: TextStyle(fontSize: 18)),

                    // Thêm TweenAnimationBuilder vào PieChart
                    SizedBox(
                      height: 250,
                      child: TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1), // Hiệu ứng từ 0 đến 1
                        duration: Duration(seconds: 1), // Thời gian cho hiệu ứng
                        builder: (context, value, child) {
                          return Transform.rotate(
                            angle: value * 2 * 3.14159, // Xoay vòng biểu đồ theo giá trị 'value'
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 0,
                                centerSpaceRadius: 50,
                                sections: [
                                  PieChartSectionData(
                                    color: Colors.blue,
                                    value: (totalProductsSold * 0.6) * value, // Dùng totalProductsSold cho phần này
                                    title: '${((totalProductsSold * 0.6) * value).toStringAsFixed(0)}%',
                                    radius: 50,
                                    titleStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  PieChartSectionData(
                                    color: Colors.orange,
                                    value: (totalCustomers * 0.4) * value, // Dùng totalCustomers cho phần này
                                    title: '${((totalCustomers * 0.4) * value).toStringAsFixed(0)}%',
                                    radius: 50,
                                    titleStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16),

                    // Pie Chart Legend
                    Row(
                      children: [
                        LegendItem(color: Colors.blue, label: 'SL Sản phẩm'),
                        SizedBox(width: 8),
                        LegendItem(color: Colors.orange, label: 'SL Khách hàng'),
                      ],
                    ),
                    SizedBox(height: 32),

                    // Bar Chart Section
                    Text(
                      'Biểu đồ cột',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),

                    // Bar chart section
              // Bar Chart Section
              SizedBox(
                height: 250,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceBetween,
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                    ),
                    borderData: FlBorderData(show: true),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            fromY: 0,
                            toY: totalProductsSold.toDouble(),  // Ensure totalProductsSold is a double
                            color: Colors.blue,
                            width: 25,
                            borderRadius: BorderRadius.zero,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            fromY: 0,
                            toY: totalCustomers.toDouble(),  // Ensure totalCustomers is a double
                            color: Colors.orange,
                            width: 25,
                            borderRadius: BorderRadius.zero,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),


              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LegendItem(color: Colors.blue, label: 'Sản phẩm bán'),
                  SizedBox(width: 16),
                  LegendItem(color: Colors.orange, label: 'Khách hàng'),
                ],
              ),
            ], //children
                ),
              );
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final VoidCallback onTap;
  final dynamic animateValue;  // Thêm trường animateValue

  DashboardCard({
    required this.title,
    required this.value,
    required this.color,
    required this.onTap,
    required this.animateValue,  // Thêm tham số animateValue
  });

  @override
  Widget build(BuildContext context) {
    // Chuyển đổi value sang double nếu nó là String
    final double animateValueDouble = (animateValue is String)
        ? double.tryParse(animateValue) ?? 0.0 // Nếu animateValue là String, chuyển sang double
        : animateValue.toDouble();  // Nếu animateValue đã là double, giữ nguyên

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),

              // Sử dụng TweenAnimationBuilder để tạo hiệu ứng tăng số
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: animateValueDouble), // Hiệu ứng từ 0 đến giá trị hiện tại
                duration: Duration(seconds: 2), // Thời gian hiệu ứng
                builder: (context, value, child) {
                  return Text(
                    value.toStringAsFixed(0), // Hiển thị giá trị sau khi đã tăng dần
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Legend item widget for Pie and Bar charts
class LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
        ),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
