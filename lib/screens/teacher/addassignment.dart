import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:chatapp/providers/authprovider.dart';
import 'package:chatapp/providers/cloudStorage.dart';
import 'package:chatapp/providers/firestoreprovider.dart';
import 'package:chatapp/providers/utlitiesProvider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rounded_date_picker/src/material_rounded_date_picker_style.dart';

class AddAssignment extends StatefulWidget {
  static const routeName = "AddAssignments";

  @override
  _AddAssignmentState createState() => _AddAssignmentState();
}

enum SingingCharacter { pdf, photo }

class _AddAssignmentState extends State<AddAssignment> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  SingingCharacter _character = SingingCharacter.pdf;
  File assignmentFIle;

  List<File> files = [];
  List<String> urls = [];
  bool isLoading = false;

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

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final List<dynamic> args = ModalRoute.of(context).settings.arguments;
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    UtilitesPro utilitesPro = Provider.of<UtilitesPro>(context, listen: false);
    CloudStorageProvider cloud =
        Provider.of<CloudStorageProvider>(context, listen: false);

    FireStoreProvider fire =
        Provider.of<FireStoreProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff132743),
        title: Text(args[0]),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  "Add New Assignment",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                textFiled(
                  "Title",
                  Icon(
                    Icons.assignment,
                    color: Colors.black,
                  ),
                  titleController,
                ),
                textFiled(
                  "Description",
                  Icon(
                    Icons.description,
                    color: Colors.black,
                  ),
                  descriptionController,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    "Assignment File",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
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
                  ],
                ),
                Text(
                  "Deadline",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Selector<UtilitesPro, String>(
                  builder: (context, times, child) {
                    return ListTile(
                      title: Text(times),
                      trailing: IconButton(
                        onPressed: () async {
                          final timePicked = await showRoundedTimePicker(
                            context: context,
                            initialTime: utilitesPro.timeOfDay,
                            borderRadius: 25,
                            theme: ThemeData(
                              primarySwatch: Colors.blueGrey,
                            ),
                          );
                          if (timePicked != null) {
                            utilitesPro.changeTime(timePicked);
                          }
                        },
                        icon: Icon(Icons.timer_rounded),
                      ),
                    );
                  },
                  selector: (context, time) => time.getTime(context),
                ),
                Selector<UtilitesPro, DateTime>(
                  builder: (context, dates, child) {
                    DateFormat format = DateFormat();
                    String dateT = format.add_yMMMd().format(dates);
                    return ListTile(
                      title: Text(dateT),
                      trailing: IconButton(
                        onPressed: () async {
                          DateTime newDateTime = await showRoundedDatePicker(
                              context: context,
                              initialDate: dates,
                              firstDate: DateTime(DateTime.now().year - 1),
                              lastDate: DateTime(DateTime.now().year + 1),
                              borderRadius: 16,
                              height: size.height / 2.5,
                              theme: ThemeData(
                                primarySwatch: Colors.blueGrey,
                              ),
                              styleDatePicker: MaterialRoundedDatePickerStyle(
                                paddingDatePicker: EdgeInsets.all(0),
                                paddingMonthHeader: EdgeInsets.all(5),
                                paddingActionBar: EdgeInsets.all(0),
                                paddingDateYearHeader: EdgeInsets.all(15),
                              ));
                          if (newDateTime != null) {
                            utilitesPro.changeDate(newDateTime);
                          }
                        },
                        icon: Icon(Icons.timer_rounded),
                      ),
                    );
                  },
                  selector: (context, date) => date.getDate(),
                ),
              ],
            ),
            isLoading == false
                ? ButtonTheme(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minWidth: size.width / 1.6,
                    height: size.height / 15,
                    buttonColor: Color(0xff132743),
                    child: RaisedButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        String uid = await authProvider.getUid();
                        print(uid);
                        if (titleController.text != null) {
                          urls = await uploadAssignment(
                            type: titleController.text,
                            cloudStorageProvider: cloud,
                            fireStoreProvider: fire,
                            files: files,
                            uid: uid,
                          );
                          print(urls.length);
                          String type;
                          if (_character == SingingCharacter.photo) {
                            type = "photo";
                          } else {
                            type = "Pdf";
                          }
                          await fire.uploadtask(
                              rid: args[1],
                              type: "Assignments",
                              assignment: {
                                "Title": titleController.text,
                                "Description": descriptionController.text,
                                "fileType": type,
                                "fileUrls": urls,
                                "deadline":
                                    Timestamp.fromDate(utilitesPro.getOne()),
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
                              content: Text("Please give me the title"),
                            ),
                          );
                        }
                      },
                      textColor: Colors.white,
                      child: Text(
                        "Upload Task",
                        style: TextStyle(fontSize: 20),
                      ),
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

  uploadAssignment({
    String type,
    List<File> files,
    String uid,
    CloudStorageProvider cloudStorageProvider,
    FireStoreProvider fireStoreProvider,
  }) async {
    try {
      List<String> urls = [];
      urls = await cloudStorageProvider.uploadTask(
          files: files, uid: uid, type: type, way: "Assignments");

      return urls;
    } catch (erorr) {}
  }

  Widget textFiled(String hint, Icon icon, TextEditingController controller) {
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
}
