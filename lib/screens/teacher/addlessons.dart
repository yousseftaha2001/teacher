import 'dart:io';

import 'package:chatapp/providers/authprovider.dart';
import 'package:chatapp/providers/cloudStorage.dart';
import 'package:chatapp/providers/firestoreprovider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum SingingCharacter { pdf, photo, video }

class AddLessons extends StatefulWidget {
  static const routeName = "AddLessons";

  @override
  _AddLessonsState createState() => _AddLessonsState();
}

class _AddLessonsState extends State<AddLessons> {
  TextEditingController titleCont = TextEditingController();

  TextEditingController desCont = TextEditingController();

  SingingCharacter _character = SingingCharacter.pdf;

  List<File> files = [];
  List<String> urls = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final List<dynamic> args = ModalRoute.of(context).settings.arguments;
    final size = MediaQuery.of(context).size;
    final FireStoreProvider fire =
        Provider.of<FireStoreProvider>(context, listen: false);
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    final CloudStorageProvider cloud =
        Provider.of<CloudStorageProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff132743),
        title: Text(args[0]),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Add Lesson",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            textFiled(
              hint: "Title",
              icon: Icon(Icons.title),
              controller: titleCont,
            ),
            textFiled(
              hint: "Description",
              icon: Icon(Icons.description_outlined),
              controller: desCont,
            ),
            Column(
              children: [
                ListTile(
                  title: const Text('pdf'),
                  leading: Radio(
                    value: SingingCharacter.pdf,
                    groupValue: _character,
                    activeColor: Color(0xff132743),
                    onChanged: (SingingCharacter value) {
                      print(_character);
                      setState(() {
                        _character = value;
                      });
                    },
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.attach_file),
                    onPressed: () async {
                      files = await _pickFile();
                    },
                  ),
                ),
                ListTile(
                  title: const Text('photo'),
                  leading: Radio(
                    value: SingingCharacter.photo,
                    groupValue: _character,
                    activeColor: Color(0xff132743),
                    onChanged: (SingingCharacter value) {
                      print(_character);
                      setState(() {
                        _character = value;
                      });
                    },
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.attach_file),
                    onPressed: () async {
                      files = await _pickFile();
                    },
                  ),
                ),
                ListTile(
                  title: const Text('video'),
                  leading: Radio(
                    value: SingingCharacter.video,
                    groupValue: _character,
                    activeColor: Color(0xff132743),
                    onChanged: (SingingCharacter value) {
                      print(_character);
                      setState(() {
                        _character = value;
                      });
                    },
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.attach_file),
                    onPressed: () async {
                      files = await _pickFile();
                    },
                  ),
                ),
              ],
            ),
            isLoading == false
                ? ButtonTheme(
                    minWidth: size.width / 2,
                    height: size.height / 14,
                    buttonColor: Color(0xff132743),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: RaisedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        if (titleCont.value != null && files.length != 0) {
                          String uid = await authProvider.getUid();
                          urls = await uploadAssignment(
                            type: titleCont.text,
                            cloudStorageProvider: cloud,
                            files: files,
                            uid: uid,
                          );
                          String type;
                          if (_character == SingingCharacter.photo) {
                            type = "photo";
                          } else if (_character == SingingCharacter.pdf) {
                            type = "Pdf";
                          } else {
                            type = "video";
                          }
                          await fire.uploadtask(
                              rid: args[1],
                              type: "Lessons",
                              assignment: {
                                "Title": titleCont.text,
                                "Description": desCont.text,
                                "fileType": type,
                                "fileUrls": urls,
                                "Created": Timestamp.now(),
                              });

                          setState(() {
                            isLoading = false;
                          });
                          Navigator.pop(context);
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text("please enter a title or files"),
                            ),
                          );
                        }
                      },
                      textColor: Colors.white,
                      child: Text("Upload Lesson"),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
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

  uploadAssignment({
    String type,
    List<File> files,
    String uid,
    CloudStorageProvider cloudStorageProvider,
  }) async {
    try {
      List<String> urls = [];
      urls = await cloudStorageProvider.uploadTask(
          files: files, uid: uid, type: type, way: "Lessons");

      return urls;
    } catch (erorr) {}
  }

  Future _pickFile() async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path)).toList();
      return files;
    } else {
      // User canceled the picker
    }
  }
}
