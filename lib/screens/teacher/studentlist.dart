import 'package:chatapp/providers/firestoreprovider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentsList extends StatelessWidget {
  static const routeName = "StudentList";
  final roomName;
  final roomId;

  StudentsList({this.roomName, this.roomId});

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
        stream: fire.studentsList(rid: args[1]),
        builder: (context, stduentsSnap) {
          if (stduentsSnap.hasError) {
            return Center(
              child: Text(stduentsSnap.error.toString()),
            );
          }
          if (stduentsSnap.connectionState == ConnectionState.active) {
            final studnets = stduentsSnap.data.docs;
            return ListView.builder(
              itemCount: studnets.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          radius: 40,
                        ),
                        title: Text(studnets[index].data()["name"]),
                        subtitle:Text(studnets[index].data()["email"]) ,
                        trailing: IconButton(
                          icon: Icon(Icons.delete,color: Colors.red,),
                          onPressed: () {},
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          }
          if (!stduentsSnap.hasData) {
            return Center();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
