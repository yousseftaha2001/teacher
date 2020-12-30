import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as Path;

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CloudStorageProvider extends ChangeNotifier {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String> uploadUserPhoto({File image, String uid, String type}) async {
    try {
      String name = Path.basename(image.path);
      print(name);
      final ref = storage.ref().child(uid).child("Photos").child(name);
      var result = await ref.putFile(image).onComplete;
      final url = await ref.getDownloadURL();
      print(url);
      return url;
    } catch (error) {
      print(error.toString());
      return "error";
    }
  }

  Future deleteFile({ String uid, String type,String way}) async {
    final StorageReference firebaseStorageRef =
    storage.ref().child("$uid/$way/$type");
    try {
      var name= firebaseStorageRef.path;
      print(name);
      await firebaseStorageRef.delete();
      print(name);
      return true;
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }


  Future<List<String>> uploadTask(
      {List<File> files, String uid, String type,String way}) async {
    List<String> urls = [];
    try {
      for (var file in files) {
        String name = Path.basename(file.path);
        final ref = storage
            .ref()
            .child(uid)
            .child(way)
            .child(type)
            .child(name);
        var result = await ref.putFile(file).onComplete;
        var url = await ref.getDownloadURL().then((value) => urls.add(value));
      }
      return urls;
    } catch (error) {
      print(error.toString());
      return ["error"];
    }
  }
}
