import 'package:chatapp/providers/authprovider.dart';
import 'package:chatapp/providers/firestoreprovider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTask extends StatefulWidget {
  static const routeName = "/Addtask";
  AddTask({Key key}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleCont = TextEditingController();
  TextEditingController desCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff132743),
        title: Text("Add New Task"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            textFiled(
              hint: "Title",
              icon: Icon(Icons.title, color: Color(0xff132743)),
              controller: titleCont,
            ),
            textFiled(
              hint: "Description",
              icon: Icon(
                Icons.description,
                color: Color(0xff132743),
              ),
              controller: desCont,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 400),
              child: ButtonTheme(
                minWidth: size.width / 2,
                height: size.height / 15,
                buttonColor: Color(0xff132743),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: RaisedButton(
                  onPressed: () async {
                    await submit(
                      title: titleCont.text,
                      description: desCont.text,
                      context: context,
                    );
                  },
                  textColor: Colors.white,
                  child: Text(
                    "Upload Task",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget textFiled({String hint, Icon icon, TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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

  submit({String title, String description, BuildContext context}) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    FireStoreProvider fire =
        Provider.of<FireStoreProvider>(context, listen: false);
    try {
      String uid = await authProvider.getUid();
      print(uid);
      await fire.createTask(
        userId: uid,
        task: {
          "title": title,
          "description": description,
          "created": Timestamp.now(),
        },
      );
      Navigator.pop(context);
    } catch (error) {
      print("error" + error.toString());
    }
  }
}
