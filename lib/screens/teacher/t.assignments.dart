import 'package:chatapp/providers/authprovider.dart';
import 'package:chatapp/providers/cloudStorage.dart';
import 'package:chatapp/providers/firestoreprovider.dart';
import 'package:chatapp/screens/teacher/addassignment.dart';
import 'package:chatapp/screens/teacher/assignemtsph.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'assignmentpdf.dart';

class TAssignments extends StatefulWidget {
  static const routeName = "Tassignments";

  @override
  _TAssignmentsState createState() => _TAssignmentsState();
}

class _TAssignmentsState extends State<TAssignments> {
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
    final CloudStorageProvider cloud =
        Provider.of<CloudStorageProvider>(context, listen: false);
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff132743),
        title: Text(args[0]),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fire.assignmentsT(rid: args[1], way: "Assignments"),
        builder: (context, stduentsSnap) {
          if (stduentsSnap.hasError) {
            return Center(
              child: Text(stduentsSnap.error.toString()),
            );
          }
          if (stduentsSnap.connectionState == ConnectionState.active) {
            final assignments = stduentsSnap.data.docs;
            return ListView.builder(
              itemCount: assignments.length,
              itemBuilder: (context, index) {
                Timestamp dead = assignments[index].data()["deadline"];
                DateTime deadline = dead.toDate();
                return InkWell(
                  onTap: () {
                    if (assignments[index].data()["fileType"] == "Pdf") {
                      Navigator.pushNamed(
                        context,
                        AssignemtPdf.routeName,
                        arguments: [
                          assignments[index].data()["Title"],
                          assignments[index].data()["fileUrls"],
                        ],
                      );
                    } else {
                      Navigator.pushNamed(
                        context,
                        AssignemtPhoto.routeName,
                        arguments: [
                          assignments[index].data()["Title"],
                          assignments[index].data()["fileUrls"],
                        ],
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
                          title: Text(assignments[index].data()["Title"]),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(assignments[index].data()["Description"]),
                              Text(dateFormat.format(deadline)),
                              Text(
                                timeFormat.format(deadline),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              print(assignments[index].id);
                              print(args[1]);
                              await fire.deleteTask(
                                rid: args[1],
                                type: "Assignments",
                                docId: assignments[index].id,
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
          if (!stduentsSnap.hasData) {
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
          Navigator.pushNamed(context, AddAssignment.routeName, arguments: [
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
