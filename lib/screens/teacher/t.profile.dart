import 'dart:ui';
import 'package:chatapp/providers/authprovider.dart';
import 'package:chatapp/providers/firestoreprovider.dart';
import 'package:chatapp/providers/utlitiesProvider.dart';
import 'package:chatapp/screens/loginscreen.dart';
import 'package:chatapp/services/profilemethdos.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TProfile extends StatefulWidget {
  @override
  _TProfileState createState() => _TProfileState();
}

class _TProfileState extends State<TProfile> {
  String userName;
  String userEmail;
  String imageUrl;

  getUserData() async {
    FireStoreProvider fireStoreProvider =
        Provider.of<FireStoreProvider>(context, listen: false);
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    String uid = await authProvider.getUid();
    Map<String, dynamic> map =
        await fireStoreProvider.getUserType(id: uid, room: false);
    if (map["userType"] != null && uid != null) {
      print(map["userType"]);
      print(uid);

      setState(() {
        userName = map["Email"];
        userEmail = map["Name"];
        imageUrl = map["ImageUrl"];
      });
    } else {
      print("no uid ");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserData();

    super.initState();
  }

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff132743),
        centerTitle: true,
        title: Text("Profile"),
        elevation: 10,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Container(
                height: size.height / 3.5,
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 42,
                            backgroundImage: imageUrl == null
                                ? null
                                : NetworkImage(imageUrl),
                            backgroundColor: Colors.red,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userEmail != null ? userName : "",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  userEmail != null ? userEmail : "",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.logout,
                              color: Colors.black,
                            ),
                            onPressed: () async {
                              bool done = await authProvider.signOUt();
                              if (done == true) {
                                Navigator.pushReplacementNamed(
                                    context, LogInScreen.routeName);
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  staticsCirc(double percent) {
    return CircularPercentIndicator(
      radius: 110.0,
      lineWidth: 5.0,
      percent: percent,
      center: Text(
        "${format(percent * 100)} %",
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
      progressColor: Colors.red,
    );
  }
}
