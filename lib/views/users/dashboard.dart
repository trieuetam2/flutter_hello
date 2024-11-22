import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/users/HomeScreenController.dart';
import 'package:flutter_application_1/services/userInfoRemember.dart';
import 'package:flutter_application_1/views/users/cart_screen.dart';
import 'package:flutter_application_1/views/users/detail_product_screen.dart';
import 'package:flutter_application_1/views/users/favorites_screen.dart';
import 'package:flutter_application_1/views/users/home_screen.dart';
import 'package:flutter_application_1/views/users/order_screen.dart';
import 'package:flutter_application_1/views/users/profile_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class Dashboard extends StatelessWidget {
  CurrentUSer _remberUser = Get.put(CurrentUSer());

  List<Widget> _fragmentScreen = [
    HomeScreen(),
    FavoritesScreen(),
    OrderScreen(),
    ProfileScreen(),
  ];

  List _navigationButtonPro = [
    {
      "active_icon": Icons.home,
      "none_active_icon": Icons.home_outlined,
      "label": "Home",
    },
    {
      "active_icon": Icons.favorite,
      "none_active_icon": Icons.favorite_border,
      "label": "Favorite",
    },
    {
      "active_icon": FontAwesomeIcons.boxOpen,
      "none_active_icon": FontAwesomeIcons.box,
      "label": "Order",
    },
    {
      "active_icon": Icons.person,
      "none_active_icon": Icons.person_outline,
      "label": "Profile",
    },
  ];

  RxInt _indexNumber = 0.obs;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CurrentUSer(),
      initState: (currentState) {
        _remberUser.getUserInfo();
      },
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue.shade400, 
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                // Logo ở bên trái
                ClipRRect(
                  borderRadius: BorderRadius.circular(15), // Bo tròn ảnh thành hình tròn hoặc góc bo
                  child: Image.network(
                    'https://heoipa.com/wp-content/uploads/2024/07/Bad-Piggies.png', // Thay thế bằng URL logo của bạn
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover, // Đảm bảo hình ảnh không bị kéo giãn
                  ),
                ),

                SizedBox(width: 16), // Khoảng cách giữa logo và thanh tìm kiếm
                Expanded(
                  // Thanh tìm kiếm ở giữa
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm sản phẩm...',
                        hintStyle: TextStyle(
                          fontSize: 14, // Kích thước chữ cho text gợi ý
                          color: Colors.grey, // Màu sắc cho hint text
                        ),
                        contentPadding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.blue),
                      ),
                      onChanged: (query) {
                        Get.find<HomeScreenController>().filterProducts(query);
                      },
                    ),
                    
                  ),
                ),
                SizedBox(width: 16), // Khoảng cách giữa thanh tìm kiếm và giỏ hàng
                // Biểu tượng giỏ hàng bên phải
                IconButton(
                  icon: Icon(Icons.shopping_cart, color: Colors.white),
                  onPressed: () {
                    Get.to(() => CartScreen());
                  },
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Obx(
              () => _fragmentScreen[_indexNumber.value],
            ),
          ),
          bottomNavigationBar: Obx(
            () => BottomNavigationBar(
              currentIndex: _indexNumber.value,
              onTap: (value) {
                _indexNumber.value = value;
              },
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: Colors.blue.shade300,
              unselectedItemColor: Colors.blueGrey.shade300,
              items: List.generate(4, (index) {
                var navbtnpro = _navigationButtonPro[index];
                return BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  icon: Icon(navbtnpro["none_active_icon"]), // Sửa lỗi 'non_active_icon'
                  activeIcon: Icon(navbtnpro["active_icon"]),
                  label: navbtnpro["label"],
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
