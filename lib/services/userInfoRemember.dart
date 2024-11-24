import 'dart:convert';

import 'package:flutter_application_1/models/dangki.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Userinforemember {
  
//hàm lưu thông tin user vào local stoge
  static saveRememberUser(Dangki userInfo) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userJsonData = jsonEncode(userInfo.toJson());
    await preferences.setString('currentUser', userJsonData);
    
  }
  
  //function read user
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

//logout remove user from local store
  static Future<void> removeUser() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("currentUser");
  }


//======================FOR ADMIN===============================
//hàm lưu thông tin useradmin vào local stoge
  static saveRememberUserAdmin(Dangki userInfo) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userJsonData = jsonEncode(userInfo.toJson());
    await preferences.setString('currentUserAdmin', userJsonData);
    
  }

  //function read user
  static Future<Dangki?> readUserAdmin() async{
    Dangki? currentuser;
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String? userinfo = preferences.getString('currentUserAdmin');

    if(userinfo != null){
      Map<String, dynamic> userDataMap = jsonDecode(userinfo);
      currentuser = Dangki.fromJson(userDataMap);
    }
    return currentuser;
  }

//logout remove user from local store
  static Future<void> removeUserAdmin() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("currentUserAdmin");
  }


}




//get userinfo to profile
class CurrentUSer extends GetxController{
  Rx<Dangki> _currentUser = Dangki(0, '', '', '', 0, 0).obs;

  Dangki get user => _currentUser.value;

  getUserInfo() async{
    Dangki? getUserInfoFromLocal = await Userinforemember.readUser();
    _currentUser.value = getUserInfoFromLocal!;
  }
}


//get userinfo to profile for ADMIN
class CurrentUSerAdmin extends GetxController{
  Rx<Dangki> _currentUserAdmin = Dangki(0, '', '', '', 0, 0).obs;

  Dangki get user => _currentUserAdmin.value;

  getUserInfoAdmin() async{
    Dangki? getUserInfoFromLocal = await Userinforemember.readUserAdmin();
    _currentUserAdmin.value = getUserInfoFromLocal!;
  }
}
