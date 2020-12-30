import 'package:chatapp/providers/authprovider.dart';
import 'package:chatapp/providers/firestoreprovider.dart';
import 'package:chatapp/screens/signup.dart';
import 'package:chatapp/screens/teacher/t.home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogInScreen extends StatefulWidget {
  static const routeName = "/LogIn";

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();
  bool obscure = false;
  bool isLoading = false;
  String userType;
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  @override
  void dispose() {
    userEmail.dispose();
    userPassword.dispose();
    super.dispose();
  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
  }

  getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String type = prefs.getString("UserType");
    return type;
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    FireStoreProvider fireStoreProvider =
    Provider.of<FireStoreProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xff132743),
      body: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: size.height / 8),
                Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 35,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: size.height / 40),
                Text(
                  "W E l C O M E   B A C K !",
                  style: TextStyle(
                    color: Colors.lightBlue.withOpacity(0.5),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: size.height / 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        textFiled(
                          "Email",
                          Icon(
                            Icons.person_outline,
                            color: Colors.white,
                          ),
                          userEmail,
                        ),
                        SizedBox(height: size.height / 45),
                        textFiled(
                          "Password",
                          Icon(
                            Icons.lock_outline,
                            color: Colors.white,
                          ),
                          userPassword,
                        ),
                        SizedBox(
                          height: size.height / 3.5,
                        ),
                        isLoading == false
                            ? ButtonTheme(
                                height: size.height / 15,
                                minWidth: size.width / 1.5,
                                child: RaisedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      var user = await authProvider.signIn(
                                        userEmail.text,
                                        userPassword.text,
                                      );
                                      if (user == "done") {
                                        String uid=await authProvider.getUid();
                                        Map<String,dynamic>da=await fireStoreProvider.getUserType(id: uid,room: false);

                                        if (da["userType"] == "Teacher") {
                                          Navigator.pushReplacementNamed(
                                            context,
                                            TeacherHome.routeName,
                                          );
                                        }
                                        setState(() {
                                          isLoading = false;
                                        });

                                      } else {
                                        await dialog(user);
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    }
                                  },
                                  child: Text(
                                    "Login",
                                    style: TextStyle(fontSize: 25),
                                  ),
                                  color: Colors.deepOrange,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  textColor: Colors.white,
                                ),
                              )
                            : CircularProgressIndicator(),
                        SizedBox(height: size.height / 30),
                        FlatButton(
                          onPressed: () {
                            Navigator.pushNamed(context, SignUp.routeName);
                          },
                          child: Text(
                            "Do not have an account ! Sign Up",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
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
            ? Theme(
                data: ThemeData(unselectedWidgetColor: Colors.white),
                child: Checkbox(
                  value: obscure,
                  onChanged: (val) {
                    setState(() {
                      obscure = val;
                    });
                  },
                ),
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

  Future<void> dialog(String cont) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(15),
            content: Text(
              cont,
              style: TextStyle(fontSize: 20),
            ),
            actions: [
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Try again"),
              )
            ],
          );
        });
  }
}
