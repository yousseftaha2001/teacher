import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:video_player/video_player.dart';

class LessonView extends StatefulWidget {
  static const routeName = "/Lesson view";

  LessonView({Key key}) : super(key: key);

  @override
  _LessonViewState createState() => _LessonViewState();
}

class _LessonViewState extends State<LessonView> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  VideoPlayerController _controller;
  @override
  Widget build(BuildContext context) {
    final List<dynamic> args = ModalRoute.of(context).settings.arguments;
    if (args[0] == "photo") {
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
    } else if (args[0] == "pdf") {
      return Scaffold(
        appBar: AppBar(
          title: Text(args[2]),
          backgroundColor: Color(0xff132743),
          centerTitle: true,
        ),
        body: SfPdfViewer.network(
          args[1][0],
          key: _pdfViewerKey,
          enableDoubleTapZooming: true,
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Text("No data"),
        ),
      );
    }
  }
}
