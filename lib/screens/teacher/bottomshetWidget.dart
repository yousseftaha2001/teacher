import 'package:chatapp/providers/authprovider.dart';
import 'package:chatapp/providers/firestoreprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomSheetEx extends StatefulWidget {
  @override
  _BottomSheetExState createState() => _BottomSheetExState();
}

class _BottomSheetExState extends State<BottomSheetEx> {
  GlobalKey<FormState> formKy = GlobalKey();
  TextEditingController titleCont = TextEditingController();
  TextEditingController rulesCont = TextEditingController();

  makeRoom(AuthProvider auth, FireStoreProvider fire,
      Map<String, dynamic> data) async {
    String uid = await auth.getUid();
    String roomUid = await fire.makeNewRoom(uid: uid, data: {
      "rules": data["rules"],
      "title": data["title"],
      "TeacherId": uid,
      "Maximum Students": data["max"],
    });
    await fire.updateUser("Teacher", uid, {"roomId": roomUid});
    print(roomUid);
    return roomUid;
  }

  int students = 10;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    FireStoreProvider fire =
        Provider.of<FireStoreProvider>(context, listen: false);
    return Container(
      child: Container(
        color: Colors.transparent,
        height: size.height / 2,
        child: BottomSheet(
          onClosing: () {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          builder: (ctx) {
            return Column(
              children: [
                Container(
                  color: Color(0xff132743),
                  height: size.height / 80,
                  width: size.width / 2,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    "Create a Room",
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Form(
                  key: formKy,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        textFiled(
                          "Title",
                          Icon(
                            Icons.article_outlined,
                            color: Colors.black,
                          ),
                          titleCont,
                        ),
                        SizedBox(
                          height: size.height / 50,
                        ),
                        textFiled(
                          "Rules",
                          Icon(
                            Icons.list,
                            color: Colors.black,
                          ),
                          rulesCont,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Maximum students",
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButton(
                        iconSize: 40,
                        items: [
                          DropdownMenuItem(
                            child: Text("10"),
                            value: 10,
                          ),
                          DropdownMenuItem(
                            child: Text("20"),
                            value: 20,
                          ),
                          DropdownMenuItem(
                            child: Text("30"),
                            value: 30,
                          ),
                        ],
                        value: students,
                        onChanged: (val) {
                          setState(() {
                            students = val;
                          });
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height / 15,
                ),
                ButtonTheme(
                  buttonColor: Color(0xff132743),
                  height: size.height / 17,
                  minWidth: size.width / 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: RaisedButton(
                    onPressed: () async {
                      String id=await makeRoom(
                        auth,
                        fire,
                        {
                          "title":titleCont.text,
                          "rules":rulesCont.text,
                          "max":students
                        },
                      );
                      print(id);
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: Text(
                      "Create",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget textFiled(String hint, Icon icon, TextEditingController controller) {
    return TextFormField(
      style: TextStyle(color: Colors.black, fontSize: 18),
      cursorColor: Colors.black,
      controller: controller,
      validator: (val) {
        if (hint == "Title" || hint == "Rules") {
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
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: icon,
        labelText: hint,
        labelStyle: TextStyle(
          color: Colors.black.withOpacity(0.4),
          fontSize: 17,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}
