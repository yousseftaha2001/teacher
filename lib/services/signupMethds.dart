import 'dart:io';

import 'package:chatapp/providers/authprovider.dart';
import 'package:chatapp/providers/cloudStorage.dart';
import 'package:chatapp/providers/firestoreprovider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpMethdos {
  static Map<String, dynamic> userData({
    String userImageUrl,
    String name,
    String email,
    String password,
    String phone,
    String userType,
  }) {
    Map<String, dynamic> data = {
      "Name": name,
      "Email": email,
      "Password": password,
      "Phone": phone,
      "ImageUrl": userImageUrl,
      "userType":userType,
    };
    return data;
  }

  static addUser(
      {AuthProvider authProvider, String email, String password}) async {
    try {
      String user = await authProvider.createNewUser(
        email: email,
        password: password,
      );
      return user;
    } catch (error) {
      print("error from add user in sign up methdos");
      print(error.toString());
      return error;
    }
  }

  static uploadUserPhoto(
      {CloudStorageProvider cloud, File image, String uid, String kind}) async {
    try {
      String url = await cloud.uploadUserPhoto(
        uid: uid,
        image: image,
        type: kind,
      );
      return url;
    } catch (error) {
      print(error.toString());
      return error;
    }
  }

  static addUserToStore(
      {FireStoreProvider fireStore,
      String uid,
      Map<String, dynamic> data,
      String userType}) async {
    try {
      String add =
          await fireStore.addUser(type: userType, userdata: data, uid: uid);
      print("added user done from sign up mesthods");
      return add;
    } catch (error) {
      print(error.toString());
      return error;
    }
  }
  static setUserType(String userType)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("UserType", userType);
  }
}
