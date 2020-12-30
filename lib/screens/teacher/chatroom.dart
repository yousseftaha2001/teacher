import 'package:chatapp/providers/firestoreprovider.dart';
import 'package:chatapp/screens/teacher/messagebubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TChatRoom extends StatefulWidget {
  static const routeName = "ChatRoom";
  final String chatRoomName;
  final String chatId;
  final String userId;

  TChatRoom({this.chatRoomName, this.chatId, this.userId});

  @override
  _TChatRoomState createState() => _TChatRoomState();
}

class _TChatRoomState extends State<TChatRoom> {
  TextEditingController messageCont = TextEditingController();

  Future<Function> sendMessage({String rid, Map<String, dynamic> data}) async {
    FireStoreProvider fireStoreProvider =
        Provider.of<FireStoreProvider>(context, listen: false);
    await fireStoreProvider.addMessage(
      rid: rid,
      message: data,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> args = ModalRoute.of(context).settings.arguments;
    final size = MediaQuery.of(context).size;
    FireStoreProvider fireStoreProvider =
        Provider.of<FireStoreProvider>(context, listen: false);
    print(args);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(args[0]),
        backgroundColor: Color(0xff132743),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  height: size.height / 1.3,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Rooms")
                        .doc(args[1])
                        .collection("Chats")
                        .orderBy("created", descending: true)
                        .snapshots(),
                    builder: (context, data) {
                      if (data.connectionState == ConnectionState.active) {
                        final chatDocs = data.data.docs;
                        return ListView.builder(
                          reverse: true,
                          itemCount: chatDocs.length,
                          itemBuilder: (context, index) {
                            String id = chatDocs[index].data()["sender"];
                            Timestamp time = chatDocs[index].data()["created"];
                            DateTime date = time.toDate();
                            print(id);
                            bool isme;
                            if (id == args[2]) {
                              isme = true;
                            } else {
                              isme = false;
                            }
                            return Message(
                              message: chatDocs[index].data()["message"],
                              isMe: isme,
                              userName: "youssef",
                              key: ValueKey(chatDocs[index].id),
                              datet: date,
                            );
                          },
                        );
                      }
                      if (data.hasError) {
                        return Center(
                          child: Text(data.data.toString()),
                        );
                      }
                      if (!data.hasData) {
                        return Center(
                          child: Text("No messages"),
                        );
                      }
                      if (data.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Center(
                          child: Text(data.data.docs.length.toString()),
                        );
                      }
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: messageCont,
                          decoration: InputDecoration(
                            labelText: 'Send a message...',
                            labelStyle: TextStyle(color: Color(0xff132743)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff132743)),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff132743)),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        color: Theme.of(context).primaryColor,
                        icon: Icon(
                          Icons.send,
                        ),
                        onPressed: () async {
                          if (messageCont.text.isEmpty) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("please enter a message"),
                            ));
                          } else {
                            sendMessage(rid: args[1], data: {
                              "sender": args[2],
                              "created": Timestamp.now(),
                              "message": messageCont.text,
                            });
                            messageCont.clear();
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
