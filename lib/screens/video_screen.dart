import 'package:siraf3/widgets/my_back_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';

import '../helpers.dart';
import '../themes.dart';

class VideoScreen extends StatefulWidget {
  String videoUrl;
  String? title;

  VideoScreen({required this.videoUrl, this.title, Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  VideoPlayerController? _controller;

  bool _isLoading = false;

  int currentVideoIndex = 0;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _isLoading = true;

    loadVideo(widget.videoUrl);
  }

  loadVideo(url) {
    _controller?.dispose();
    setState(() {});
    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        setState(() {});
        _controller?.play();
      }).catchError((_) {
        notify("خطایی پیش آمد مجدد تلاش کنید");
        setState(() {
          _isLoading = false;
        });
      });
    _controller?.addListener(() {
      setState(() {});
    });
  }

  bool _showControllers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title ?? "",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
            )),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.black,
        ),
        leading: MyBackButton(color: Themes.iconLight),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: toggleControllers,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
          ),
          Center(
            child: _controller != null && _controller!.value.isInitialized
                ? GestureDetector(
                    onTap: toggleControllers,
                    child: AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    ),
                  )
                : (_isLoading
                    ? SpinKitRing(
                        color: Themes.iconLight,
                        size: 40,
                        lineWidth: 5,
                      )
                    : Container()),
          ),
          if (_showControllers)
            GestureDetector(
              onTap: toggleControllers,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          if (_showControllers)
            Align(
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () {
                  if (_controller?.value.isPlaying ?? false) {
                    _controller?.pause();
                  } else {
                    _controller?.play();
                  }
                },
                icon: Stack(
                  children: [
                    Icon(
                      (_controller?.value.isPlaying ?? false)
                          ? CupertinoIcons.pause_fill
                          : CupertinoIcons.play_fill,
                      size: 44,
                      color: Themes.primary,
                    ),
                    Icon(
                      (_controller?.value.isPlaying ?? false)
                          ? CupertinoIcons.pause_fill
                          : CupertinoIcons.play_fill,
                      size: 40,
                      color: Themes.iconLight,
                    ),
                  ],
                ),
              ),
            ),
          if (_showControllers)
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      timeText(
                          minute: _controller?.value.duration.inMinutes,
                          second: _controller?.value.duration.inSeconds
                              .remainder(60)),
                      style: TextStyle(color: Colors.white),
                    ),
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Slider(
                          value: (_controller?.value.position.inSeconds ?? 0)
                              .toDouble(),
                          min: 0,
                          max: (_controller?.value.duration.inSeconds ?? 0)
                              .toDouble(),
                          activeColor: Themes.primary,
                          onChanged: (value) {
                            setState(() {
                              _controller
                                  ?.seekTo(Duration(seconds: value.toInt()));
                            });
                          },
                        ),
                      ),
                    ),
                    Text(
                      timeText(
                          minute: _controller?.value.position.inMinutes,
                          second: _controller?.value.position.inSeconds
                              .remainder(60)),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void toggleControllers() async {
    setState(() {
      _showControllers = !_showControllers;
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    super.dispose();
    _controller?.dispose();
  }

  String timeText({int? hour, int? minute, int? second}) {
    String? hourText;
    String? minuteText;
    String? secondText;

    String finalTime = "";

    if (hour != null) {
      hourText = hour.toString();
      if (hour == 0) {
        hourText = "00";
      }
      if (hour < 10) {
        hourText = "0${hour}";
      }
    }

    finalTime += hourText ?? "";

    if (minute != null) {
      minuteText = minute.toString();
      if (minute == 0) {
        minuteText = "00";
      }
      if (minute < 10) {
        minuteText = "0${minute}";
      }
    } else {
      minuteText = "00";
    }

    finalTime += (finalTime.isNotNullOrEmpty() ? ":" : "") + minuteText;

    if (second != null) {
      secondText = second.toString();
      if (second == 0) {
        secondText = "00";
      }
      if (second < 10) {
        secondText = "0${second}";
      }
    } else {
      secondText = "00";
    }

    finalTime += ":" + secondText;

    return finalTime;
  }
}
