import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoApp extends StatefulWidget {
  String fileUrl;
  String fileName;
  VideoApp({this.fileName, this.fileUrl});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.fileUrl)
      ..initialize().then(
        (_) {
          setState(() {});
        },
      );
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: widget.fileName,
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.fileName),
          backgroundColor: Color(0xff132743),
          centerTitle: true,
        ),
        body: Center(
          child: _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : CircularProgressIndicator(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xff132743),
          onPressed: () {
            setState(
              () {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              },
            );
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
