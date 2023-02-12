import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MiniVideo extends StatefulWidget {
  ImageProvider<Object> thumbnail;
  BoxFit? imageFit;
  String videoUrl;

  MiniVideo(
      {required this.thumbnail,
      required this.videoUrl,
      this.imageFit,
      super.key});

  @override
  State<MiniVideo> createState() => _MiniVideoState();
}

class _MiniVideoState extends State<MiniVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');

    _controller.initialize().then(_onLinkLoaded).onError((error, stackTrace) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(
            children: [
              GestureDetector(
                onTap: () {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
              if (!_controller.value.isPlaying)
                GestureDetector(
                  onTap: () {
                    _controller.play();
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.play_arrow_outlined,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
            ],
          )
        : Stack(
            children: [
              Image(
                image: widget.thumbnail,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: widget.imageFit ?? BoxFit.cover,
                errorBuilder: (_, _1, _2) {
                  return Image(
                    image: AssetImage("assets/images/image_not_avialable.png"),
                    width: MediaQuery.of(context).size.width,
                    fit: widget.imageFit ?? BoxFit.cover,
                    height: MediaQuery.of(context).size.height,
                    color: Color(0x757f8c8d),
                  );
                },
              ),
            ],
          );
  }

  FutureOr _onLinkLoaded(_) {
    setState(() {});

    _controller.addListener(() {
      setState(() {
        if (!_controller.value.isPlaying &&
            _controller.value.isInitialized &&
            (_controller.value.duration == _controller.value.position)) {
          _controller.seekTo(Duration(seconds: 0));
          _controller.play();
        }
      });
    });
  }
}
