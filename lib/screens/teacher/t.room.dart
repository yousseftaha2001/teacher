import 'dart:ui';

import 'package:chatapp/providers/authprovider.dart';
import 'package:chatapp/providers/firestoreprovider.dart';
import 'package:chatapp/screens/teacher/addlessons.dart';
import 'package:chatapp/screens/teacher/bottomshetWidget.dart';
import 'package:chatapp/screens/teacher/chatroom.dart';
import 'package:chatapp/screens/teacher/lessons.dart';
import 'package:chatapp/screens/teacher/studentlist.dart';
import 'package:chatapp/screens/teacher/t.assignments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Rooms extends StatefulWidget {
  @override
  _RoomsState createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> with SingleTickerProviderStateMixin {
  String roomid;
  DocumentSnapshot room;
  String roomName;
  bool show = false;
  String userId;

  getRoomId() async {
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    FireStoreProvider fire =
        Provider.of<FireStoreProvider>(context, listen: false);
    String uid = await auth.getUid();
    String roomId = await fire.getUserType(id: uid, room: true);
    if (roomId != null) {
      print(roomId);
      setState(() {
        userId = uid;
        roomid = roomId;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getRoomId();
  }

  @override
  Widget build(BuildContext context) {
    print("build has built");
    final size = MediaQuery.of(context).size;
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    FireStoreProvider fire =
        Provider.of<FireStoreProvider>(context, listen: false);
    return FutureBuilder<DocumentSnapshot>(
      future: fire.getRoom(rid: roomid),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snap) {
        if (snap.hasError) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Color(0xff132743),
              title: Text("Room"),
            ),
            body: Center(
              child: Text(snap.error.toString()),
            ),
          );
        }
        if (snap.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Color(0xff132743),
              title: Text("Room"),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (!snap.data.exists) {
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Color(0xff132743),
                title: Text("Room"),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "You do not have any room yet",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Transform.rotate(
                      angle: -260,
                      child: Icon(
                        Icons.arrow_back_outlined,
                        size: 130,
                      ),
                    ),
                    Text(
                      "Create One",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: Color(0xff132743),
                elevation: 5,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    enableDrag: true,
                    isDismissible: true,
                    elevation: 20,
                    backgroundColor: Colors.transparent,
                    builder: (context) => SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: BottomSheetEx(),
                      ),
                    ),
                  );
                },
              ));
        }
        if (snap.connectionState == ConnectionState.done) {
          if (snap.hasData) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Color(0xff132743),
                title: Text(snap.data["title"]),
              ),
              body: GridView(
                padding: EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisSpacing: 2),
                children: [
                  contPaint(
                    "ChatRoom",
                    size.height / 5,
                    size.width / 1.5,
                    () {
                      print("object");
                      Navigator.pushNamed(
                        context,
                        TChatRoom.routeName,
                        arguments: [
                          snap.data["title"],
                          snap.data.id,
                          snap.data["TeacherId"],
                        ],
                      );
                    },
                    Icon(
                      Icons.messenger,
                      color: Colors.white,
                    ),
                  ),
                  contPaint(
                    "Students list",
                    size.height / 5,
                    size.width / 1.5,
                    () {
                      print("object");
                      Navigator.pushNamed(context, StudentsList.routeName,
                          arguments: [
                            snap.data["title"],
                            snap.data.id,
                          ]);
                    },
                    Icon(
                      Icons.list_alt_outlined,
                      color: Colors.white,
                    ),
                  ),
                  contPaint(
                    "Assignments",
                    size.height / 5,
                    size.width / 1.5,
                    () {
                      print("object");
                      Navigator.pushNamed(context, TAssignments.routeName,
                          arguments: [
                            snap.data["title"],
                            snap.data.id,
                          ]);
                    },
                    Icon(
                      Icons.assignment,
                      color: Colors.white,
                    ),
                  ),
                  contPaint(
                    "Lessons",
                    size.height / 5,
                    size.width / 1.5,
                    () {
                      Navigator.pushNamed(
                        context,
                        Lessons.routeName,
                        arguments: [
                          snap.data["title"],
                          snap.data.id,
                        ],
                      );
                      print("object");
                    },
                    Icon(
                      Icons.school,
                      color: Colors.white,
                    ),
                  ),
                  contPaint(
                    "Delete",
                    size.height / 5,
                    size.width / 1.5,
                    () async {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Warning'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text('Do you want delete this room?'),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text(
                                  'Yes i want',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                onPressed: () async {
                                  await fire.deleteRoom(
                                    rid: roomid,
                                    uid: userId,
                                    type: "Teacher",
                                  );
                                  setState(() {});
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text(
                                  'No',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            );
          } else {
            return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: Color(0xff132743),
                  title: Text("Room"),
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "You do not have any room yet",
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Transform.rotate(
                        angle: -260,
                        child: Icon(
                          Icons.arrow_back_outlined,
                          size: 130,
                        ),
                      ),
                      Text(
                        "Create One",
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  backgroundColor: Color(0xff132743),
                  elevation: 5,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      enableDrag: true,
                      isDismissible: true,
                      elevation: 20,
                      backgroundColor: Colors.transparent,
                      builder: (context) => SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: BottomSheetEx(),
                        ),
                      ),
                    );
                  },
                ));
          }
        } else {
          return Scaffold(
            body: Center(
              child: Text("There is error"),
            ),
          );
        }
      },
    );
  }

  contPaint(
      String title, double height, double width, Function function, Icon icon) {
    return InkWell(
      onTap: function,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff132743),
          borderRadius: BorderRadius.circular(10),
        ),
        height: height,
        width: width,
        margin: EdgeInsets.all(12),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
