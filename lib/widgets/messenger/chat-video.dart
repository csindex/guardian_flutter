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
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.url);

    _initializeVideoPlayerFuture = _controller.initialize();

    _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    debugPrint('CmVideoPlayer - dispose()');
  }

  @override
  Widget build(BuildContext context) {
    print('VIDEO URL-${widget.url}');
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the VideoPlayerController has finished initialization, use
          // the data it provides to limit the aspect ratio of the video.
          return Container(
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  // Use the VideoPlayer widget to display the video.
                  child: VideoPlayer(_controller),
                ),
                IconButton(
                  onPressed: () {
                    // Wrap the play or pause in a call to `setState`. This ensures the
                    // correct icon is shown.
                    setState(() {
                      // If the video is playing, pause it.
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        // If the video is paused, play it.
                        _controller.play().catchError((dynamic error) => print('play error - $error'));
                      }
                    });
                  },
                  icon: Icon(_controller.value.isPlaying ?
                    Icons.pause :
                    Icons.play_arrow,
                  ),
                ),
              ],
            ),
          );
        } else {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner.
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

}

/*class _ChatVideoState extends State<ChatVideo> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller?.dispose();
    _controller = VideoPlayerController.network(widget.url)..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    }).catchError((dynamic error) => print('Video player initialize error: $error'));
    _controller.play().catchError((dynamic error) => print('Video player play error: $error'));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    debugPrint('CmVideoPlayer - dispose()');
  }

  @override
  Widget build(BuildContext context) {
    print('VIDEO URL-${widget.url}');
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

}*/

/*class _ChatVideoState extends State<ChatVideo> {
  final FijkPlayer _player = FijkPlayer();

  @override
  void initState() {
    super.initState();
    _player.setDataSource(widget.url, autoPlay: true);
  }

  @override
  void dispose() {
    super.dispose();
    _player.release();
  }

  @override
  Widget build(BuildContext context) {
    print('VIDEO URL-${widget.url}');
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: FijkView(
        player: _player,
      ),
    );
  }

}*/
