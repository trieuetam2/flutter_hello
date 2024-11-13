import 'dart:convert';

import 'package:flutter_application_1/models/dangki.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Userinforemember {
//save to local store info user
  static saveRememberUser(Dangki userInfo) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userJsonData = jsonEncode(userInfo.toJson());
    await preferences.setString('currentUser', userJsonData);
    
  }

  //read user
  static Future<Dangki?> readUser() async{
    Dangki? currentuser;
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String? userinfo = preferences.getString('currentUser');

    if(userinfo != null){
      Map<String, dynamic> userDataMap = jsonDecode(userinfo);
      currentuser = Dangki.fromJson(userDataMap);
    }
    return currentuser;
  }

}

class CurrentUSer extends GetxController{
  Rx<Dangki> _currentUser = Dangki(0, '', '', '').obs;

  Dangki get user => _currentUser.value;

  getUserInfo() async{
    Dangki? getUserInfoFromLocal = await Userinforemember.readUser();
    _currentUser.value = getUserInfoFromLocal!;
  }
}