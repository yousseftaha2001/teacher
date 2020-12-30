import 'package:chatapp/providers/firestoreprovider.dart';
import 'package:chatapp/screens/teacher/addlessons.dart';
import 'package:chatapp/screens/teacher/lessonVideo.dart';
import 'package:chatapp/screens/teacher/lessonsView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Lessons extends StatefulWidget {
  static const routeName = "Lessons";

  @override
  _LessonsState createState() => _LessonsState();
}

class _LessonsState extends State<Lessons> {
  DateFormat dateFormat = DateFormat.yMMMd();

  DateFormat timeFormat = DateFormat.jm();

  @override
  void initState() {
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(onMessage: (msg) {
      print(msg);
      return;
    }, onLaunch: (msg) {
      print(msg);
      return;
    }, onResume: (msg) {
      print(msg);
      return;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> args = ModalRoute.of(context).settings.arguments;
    FireStoreProvider fire =
        Provider.of<FireStoreProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff132743),
        title: Text(args[0]),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fire.assignmentsT(rid: args[1], way: "Lessons"),
        builder: (context, lessonsSnap) {
          if (lessonsSnap.hasError) {
            return Center(
              child: Text(lessonsSnap.error.toString()),
            );
          }
          if (lessonsSnap.connectionState == ConnectionState.active) {
            final lessons = lessonsSnap.data.docs;
            return ListView.builder(
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                Timestamp dead = lessons[index].data()["Created"];
                DateTime created = dead.toDate();
                return InkWell(
                  onTap: () {
                    if (lessons[index].data()["fileType"] != "video") {
                      Navigator.pushNamed(
                        context,
                        LessonView.routeName,
                        arguments: [
                          lessons[index].data()["fileType"],
                          lessons[index].data()["filesUrls"],
                          lessons[index].data()["Title"],
                        ],
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoApp(
                            fileName: lessons[index].data()["Title"],
                            fileUrl: lessons[index].data()["fileUrls"][0],
                          ),
                        ),
                      );
                    }
                  },
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(lessons[index].data()["Title"]),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(lessons[index].data()["Description"]),
                              Text(dateFormat.format(created)),
                              Text(
                                timeFormat.format(created),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              await fire.deleteTask(
                                rid: args[1],
                                type: "Lessons",
                                docId: lessons[index].id,
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
          if (!lessonsSnap.hasData) {
            return Center(
              child: Text("do not have data"),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddLessons.routeName, arguments: [
            args[0],
            args[1],
          ]);
        },
        backgroundColor: Color(0xff132743),
        child: Icon(Icons.add),
      ),
    );
  }
}
