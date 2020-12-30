import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthProvider extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;


  Future createNewUser({String email, String password}) async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("done");
      return "done";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return 'The account already exists for that email.';
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }
  authState()async{
    _auth.authStateChanges().listen((User user) {
      if(user!=null){
        return user;
      }else{
        return "user is not here";
      }
    });
  }
  signOUt()async{
    try{
      await _auth.signOut();
      return true;
    }catch(err){
      print(err.toString());
      return false;
    }
  }

 Future<String> getUid() async {
    if (_auth.currentUser != null) {
      print(_auth.currentUser.uid);
      return _auth.currentUser.uid;
    } else {
      print("user did not sign up!");
      return "user did not sign up!";
    }
  }

  signIn(String email, String password) async {
    try{
      UserCredential user = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "done";
    } on FirebaseAuthException catch(e){
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return 'Wrong password provided for that user.';
      }

    }catch(e){
      print(e.toString());
      return e.toString();
    }
  }
}
