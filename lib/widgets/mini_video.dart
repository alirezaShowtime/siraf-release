import 'dart:async';

import 'package:siraf3/screens/video_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:siraf3/main.dart';

class MiniVideo extends StatefulWidget {
  ImageProvider<Object> thumbnail;
  BoxFit? imageFit;
  String videoUrl;
  bool autoReverse;
  Widget? playIcon;
  double? width;
  bool directPlay;
  Function(VideoPlayerController)? onStartVideo;

  MiniVideo({required this.thumbnail, required this.videoUrl, this.onStartVideo, this.imageFit, this.autoReverse = true, this.playIcon, this.width, this.directPlay = false, super.key});

  @override
  State<MiniVideo> createState() => MiniVideoState();
}

class MiniVideoState extends State<MiniVideo> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late VideoPlayerController _controller;

  VideoPlayerController getVideoController() => _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.videoUrl);

    _controller.initialize().then(_onLinkLoaded);
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? SizedBox(
            height: widget.width != null ? _controller.value.size.height / _controller.value.size.width * widget.width! : _controller.value.size.height,
            width: widget.width ?? _controller.value.size.width,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: !widget.directPlay ? handleVideoClick : null,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
                if (!widget.directPlay && !_controller.value.isPlaying)
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        _controller.play();
                        widget.onStartVideo?.call(_controller);
                      },
                      child: widget.playIcon ??
                          Stack(
                            children: [
                              Icon(
                                CupertinoIcons.play_fill,
                                size: 44,
                                color: App.theme.primaryColor,
                              ),
                              Icon(
                                CupertinoIcons.play_fill,
                                size: 40,
                                color: Themes.iconLight,
                              ),
                            ],
                          ),
                    ),
                  ),
                if (widget.directPlay)
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: goVideoScreen,
                      child: widget.playIcon ??
                          Stack(
                            children: [
                              Icon(
                                CupertinoIcons.play_fill,
                                size: 44,
                                color: App.theme.primaryColor,
                              ),
                              Icon(
                                CupertinoIcons.play_fill,
                                size: 40,
                                color: Themes.iconLight,
                              ),
                            ],
                          ),
                    ),
                  ),
                if (!widget.directPlay)
                  Positioned(
                    left: 5,
                    bottom: 5,
                    child: InkWell(
                      onTap: goVideoScreen,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Themes.secondary2.withOpacity(0.8),
                        ),
                        child: Icon(
                          Icons.fullscreen_outlined,
                          color: Themes.iconLight,
                          size: 30,
                        ),
                      ),
                    ),
                  )
              ],
            ),
          )
        : Center(
            child: Loading(
              size: 20.0,
              backgroundColor: Colors.transparent,
            ),
          );
  }

  FutureOr _onLinkLoaded(_) {
    setState(() {});

    _controller.addListener(() {
      setState(() {
        if (!_controller.value.isPlaying && _controller.value.isInitialized && (_controller.value.duration == _controller.value.position && widget.autoReverse)) {
          _controller.seekTo(Duration(seconds: 0));
          _controller.play();
        }
      });
    });

    widget.onStartVideo?.call(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void handleVideoClick() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
      widget.onStartVideo?.call(_controller);
    }
  }

  void goVideoScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoScreen(videoUrl: widget.videoUrl),
      ),
    );
  }
}
