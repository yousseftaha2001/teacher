import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AssignemtPdf extends StatefulWidget {
  static const routeName = "/AssignmentPdf";
  final String title;
  final List<String> url;

  const AssignemtPdf({Key key, this.title, this.url}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<AssignemtPdf> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(args[0]),
        backgroundColor: Color(0xff132743),
        centerTitle: true,
      ),
      body: SfPdfViewer.network(
        args[1][0],
        key: _pdfViewerKey,
        enableDoubleTapZooming: true,
      ),
    );
  }
}
