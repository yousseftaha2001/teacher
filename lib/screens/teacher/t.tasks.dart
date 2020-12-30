import 'package:chatapp/providers/authprovider.dart';
import 'package:chatapp/providers/firestoreprovider.dart';
import 'package:chatapp/screens/teacher/addtask.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class TTasks extends StatefulWidget {
  @override
  _TTasksState createState() => _TTasksState();
}

class _TTasksState extends State<TTasks> {
  String userId;

  getUserId() async {
    AuthProvider auth = Provider.of<AuthProvider>(
      context,
      listen: false,
    );
    var id = await auth.getUid();
    if (id != null) {
      setState(() {
        userId = id;
      });
    }
  }

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FireStoreProvider fire = Provider.of<FireStoreProvider>(
      context,
      listen: false,
    );
    TextEditingController title = TextEditingController();
    TextEditingController des = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff132743),
        title: Text("My tasks"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fire.getTasks(id: userId),
        builder: (context, tasks) {
          if (tasks.hasError) {
            return Center(
              child: Text(tasks.error.toString()),
            );
          }
          if (tasks.connectionState == ConnectionState.active) {
            final task = tasks.data.docs;
            return ListView.builder(
              itemCount: task.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Slidable(
                      child: ListTile(
                        title: Text(task[index].data()["title"]),
                        subtitle: Text(task[index].data()["description"]),
                      ),
                      actions: [
                        IconSlideAction(
                          caption: 'update',
                          color: Colors.blue,
                          icon: Icons.article,
                          onTap: () async {
                            title.text=task[index].data()["title"];
                            des.text=task[index].data()["description"];
                            await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('update your task'),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          textFiled(
                                            hint: "title",
                                            icon: Icon(
                                              Icons.article,
                                              color: Colors.grey,
                                            ),
                                            controller: title
                                          ),
                                          textFiled(
                                            hint: "description",
                                            icon: Icon(
                                              Icons.article,
                                              color: Colors.grey,
                                            ),
                                            controller: des
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Approve'),
                                        onPressed: () async {
                                          bool done = await fire.update_my_task(
                                              userId: userId,
                                              docId: task[index].id,
                                              up: {
                                                "title": title.text,
                                                "description": des.text,
                                              });
                                          if (done == true) {
                                            Navigator.of(context).pop();
                                          } else {
                                            Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "error please check your connection"),
                                              ),
                                            );
                                            Navigator.of(context).pop();
                                          }
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Cancel',style: TextStyle(color: Colors.red),),
                                        onPressed: () async {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                        ),
                      ],
                      secondaryActions: [
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.article,
                          onTap: () async {
                            bool done=await fire.deleteMytask(
                              userId: userId,
                              docId: task[index].id,
                            );
                          },
                        ),
                      ],
                      actionPane: SlidableDrawerActionPane(),
                    ),
                    Divider(
                      thickness: 1,
                      endIndent: 10,
                      indent: 10,
                      color: Colors.grey,
                    )
                  ],
                );
              },
            );
          }
          if (!tasks.hasData) {
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
          Navigator.pushNamed(context, AddTask.routeName);
        },
        backgroundColor: Color(0xff132743),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget textFiled({String hint, Icon icon, TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: TextField(
        style: TextStyle(color: Colors.black, fontSize: 18),
        cursorColor: Colors.black,
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: icon,
          labelText: hint,
          labelStyle: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
