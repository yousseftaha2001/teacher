import 'dart:io';
import 'package:chatapp/providers/authprovider.dart';
import 'package:chatapp/providers/cloudStorage.dart';
import 'package:chatapp/providers/firestoreprovider.dart';
import 'package:chatapp/services/signupMethds.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'teacher/t.home.dart';

class SignUp extends StatefulWidget {
  static const routeName = "/SignUp";

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  File _userImage;

  String userType = "";
  bool obscure = false;
  bool isloading = false;
  bool student = false;
  bool teacher = false;
  bool other = false;
  TextEditingController userName = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  TextEditingController userPhone = TextEditingController();

  Future _pickImage() async {
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _userImage = File(pickedImage.path);
      } else {
        _userImage = null;
      }
    });
  }

  @override
  void dispose() {
    userName.dispose();
    userEmail.dispose();
    userPhone.dispose();
    userPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    CloudStorageProvider cloud =
        Provider.of<CloudStorageProvider>(context, listen: false);
    FireStoreProvider fireStore =
        Provider.of<FireStoreProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Color(0xff132743),
      body: Builder(builder: (context) {
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height / 9),
              Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 35,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: size.height / 40),
              Text(
                "W h o  A r e  Y o u ?",
                style: TextStyle(
                  color: Colors.lightBlue.withOpacity(0.5),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height / 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 40,
                    backgroundImage:
                        _userImage == null ? null : FileImage(_userImage),
                    foregroundColor: Colors.white,
                  ),
                ],
              ),
              FlatButton.icon(
                onPressed: _pickImage,
                icon: Icon(
                  Icons.image,
                  color: Colors.white,
                  size: 30,
                ),
                label: Text(
                  "Add photo",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      textFiled(
                          "Name",
                          Icon(
                            Icons.person_outline,
                            color: Colors.white,
                          ),
                          userName),
                      SizedBox(height: size.height / 50),
                      textFiled(
                          "Email",
                          Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                          userEmail),
                      SizedBox(height: size.height / 50),
                      textFiled(
                        "Password",
                        Icon(
                          Icons.lock_outline,
                          color: Colors.white,
                        ),
                        userPassword,
                      ),
                      SizedBox(height: size.height / 50),
                      textFiled(
                        "Phone",
                        Icon(
                          Icons.phone_iphone,
                          color: Colors.white,
                        ),
                        userPhone,
                      ),
                      SizedBox(height: size.height / 50),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.height / 7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Student",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(height: size.height / 80),
                        ButtonTheme(
                          height: size.height / 12,
                          child: RaisedButton(
                            onPressed: () {
                              setState(() {
                                student = !student;
                                teacher = false;
                                other = false;
                                userType = "Student";
                              });
                            },
                            color: student == false
                                ? Colors.white
                                : Colors.deepOrange,
                            shape: CircleBorder(),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage("assets/student.png"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Teacher",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(height: size.height / 80),
                        ButtonTheme(
                          height: size.height / 12,
                          child: RaisedButton(
                            onPressed: () {
                              setState(() {
                                teacher = !teacher;
                                student = false;
                                other = false;
                                userType = "Teacher";
                              });
                            },
                            color: teacher == false
                                ? Colors.white
                                : Colors.deepOrange,
                            shape: CircleBorder(),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  AssetImage("assets/presentation.png"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Other",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                        SizedBox(height: size.height / 80),
                        ButtonTheme(
                          height: size.height / 12,
                          child: RaisedButton(
                            onPressed: () {
                              setState(() {
                                other = !other;
                                teacher = false;
                                student = false;
                                userType = "Other";
                                print(userType);
                              });
                            },
                            color: other == false
                                ? Colors.white
                                : Colors.deepOrange,
                            shape: CircleBorder(),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage("assets/team.png"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              isloading == true
                  ? CircularProgressIndicator()
                  : ButtonTheme(
                      height: size.height / 15,
                      minWidth: size.width / 1.5,
                      child: RaisedButton(
                        onPressed: () async {
                          if (_userImage == null || userType == "") {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Please check your photo or your title"),
                              ),
                            );
                          } else {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                isloading = true;
                              });
                              String auth=await SignUpMethdos.addUser(
                                authProvider: authProvider,
                                email: userEmail.text,
                                password: userPassword.text,
                              );
                              if(auth=="done"){
                                String uid=await authProvider.getUid();
                                String url=await SignUpMethdos.uploadUserPhoto(
                                  cloud: cloud,
                                  uid: uid,
                                  image: _userImage,
                                  kind: userType,
                                );
                                if(url!="error"){
                                  print(url);
                                  String add=await SignUpMethdos.addUserToStore(
                                    data: SignUpMethdos.userData(
                                      userImageUrl: url,
                                      name: userName.text,
                                      email: userEmail.text,
                                      password: userPassword.text,
                                      phone: userPhone.text,
                                      userType: userType,
                                    ),
                                    uid: uid,
                                    userType: userType,
                                    fireStore: fireStore
                                  );
                                  await SignUpMethdos.setUserType(userType);
                                  dialog(add);
                                  if(userType=="Teacher"){
                                    Navigator.pushReplacementNamed(
                                      context,
                                      TeacherHome.routeName,
                                    );
                                  }
                                  setState(() {
                                    isloading=false;
                                  });
                                }else{
                                  print("url is not here");
                                  setState(() {
                                    isloading=false;
                                  });
                                }
                              }else{
                                dialog(auth);
                                setState(() {
                                  isloading=false;
                                });
                              }
                            }
                          }
                        },
                        color: Colors.deepOrange,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 25),
                        ),
                        textColor: Colors.white,
                      ),
                    )
            ],
          ),
        );
      }),
    );
  }

  Widget rowIconBuilder(String text, double height, bool type) {
    return Column(
      children: [
        Text(
          "Student",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
        SizedBox(height: height / 80),
        ButtonTheme(
          height: height / 12,
          child: RaisedButton(
            onPressed: () {
              setState(() {
                student = !student;
                teacher = !teacher;
                other = !other;
              });
            },
            color: type == false ? Colors.white : Colors.deepOrange,
            shape: CircleBorder(),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage("assets/student.png"),
            ),
          ),
        ),
      ],
    );
  }



  Widget textFiled(String hint, Icon icon, TextEditingController controller) {
    return TextFormField(
      style: TextStyle(color: Colors.white, fontSize: 18),
      cursorColor: Colors.white,
      controller: controller,
      validator: (val) {
        if (hint == "Email" || hint == "Name") {
          if (val.isEmpty) {
            return "please enter a good $hint !";
          } else {
            return null;
          }
        } else {
          if (val.length <= 6) {
            return "please enter a good $hint !";
          } else {
            return null;
          }
        }
      },
      keyboardType: hint == "Name" || hint == "Email"
          ? TextInputType.text
          : TextInputType.numberWithOptions(),
      obscureText: hint == "Password" ? !obscure : false,
      decoration: InputDecoration(
        prefixIcon: icon,
        suffixIcon: hint == "Password"
            ? Checkbox(
                value: obscure,
                onChanged: (val) {
                  setState(() {
                    obscure = val;
                  });
                },
              )
            : null,
        labelText: hint,
        labelStyle: TextStyle(
          color: Colors.white.withOpacity(0.4),
          fontSize: 14,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }


  dialog(String cont){
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(15),
            content: Text(cont),
          );
        });
  }
}
