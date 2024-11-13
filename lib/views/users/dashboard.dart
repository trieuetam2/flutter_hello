import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/userInfoRemember.dart';
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
