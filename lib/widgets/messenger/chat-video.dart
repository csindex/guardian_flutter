import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class ChatVideo extends StatefulWidget {

  final String url;

  const ChatVideo({this.url});

  @override
  _ChatVideoState createState() => _ChatVideoState();

}

class _ChatVideoState extends State<ChatVideo> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    });
    _controller.play();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized ?
    ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      ),
    ) :
    CircularProgressIndicator();
  }

}
