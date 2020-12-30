import 'package:flutter/material.dart';

class AssignemtPhoto extends StatefulWidget {
  static const routeName = "AssignemtPhoto";
  AssignemtPhoto({Key key}) : super(key: key);

  @override
  _AssignemtPhotoState createState() => _AssignemtPhotoState();
}

class _AssignemtPhotoState extends State<AssignemtPhoto> {
  @override
  Widget build(BuildContext context) {
    final List<dynamic> args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(args[0]),
        backgroundColor: Color(0xff132743),
        centerTitle: true,
      ),
      body: PageView.builder(
        itemCount: args[1].length,
        itemBuilder: (context, index) {
          return Image.network(args[1][index]);
        },
      ),
    );
  }
}
