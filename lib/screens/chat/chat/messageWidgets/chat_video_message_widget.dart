import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:siraf3/bloc/chat/downloadFile/download_file_bloc.dart';
import 'package:siraf3/extensions/int_extension.dart';
import 'package:siraf3/extensions/list_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/screens/video_screen.dart';
import 'package:siraf3/widgets/my_image.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'chat_message_widget.dart';

class ChatVideoMessageWidgetState extends ChatMessageWidgetState {
  DownloadFileBloc downloadFileBloc = DownloadFileBloc();

  late AnimationController loadingController;

  void Function(void Function())? imageWidgetSetState;
  Uint8List? thumbnailPath;

  late String videoUrl;

  @override
  void initState() {
    super.initState();

    videoUrl = widget.fileMessages[0].path!;

    loadingController = AnimationController(vsync: this, duration: Duration(milliseconds: 1700))..repeat(reverse: false);

    getVideoThumbnail(videoUrl);
  }

  @override
  void dispose() {
    loadingController.dispose();
    super.dispose();
  }

  void getVideoThumbnail(String videoUrl) async {
    final fileName = await VideoThumbnail.thumbnailData(
      video: videoUrl,
      imageFormat: ImageFormat.WEBP,
    );

    imageWidgetSetState?.call(() {
      thumbnailPath = fileName;
    });
  }

  @override
  Widget content() {
    return widget.message.message == null ? onlyVideo() : withText();
  }

  Widget onlyVideo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        replyWidget(widget.message.reply, widget.onClickReplyMessage),
        Stack(
          children: [
            videoWidget(),
            Positioned(
              bottom: 5,
              right: 5,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    if (isForMe())
                      Icon(
                        widget.message.isSeen ? Icons.done_all_rounded : Icons.check_rounded,
                        color: isForMe() ? Colors.white : Colors.red,
                        size: 13,
                      ),
                    SizedBox(width: 4),
                    Text(
                      widget.message.createTime!,
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500, fontFamily: "sans-serif"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget withText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        replyWidget(widget.message.reply, widget.onClickReplyMessage),
        videoWidget(),
        textWidget(widget.message.message),
        footerWidget(false, widget.message.createTime!),
      ],
    );
  }

  Widget videoWidget() {
    return StatefulBuilder(builder: (context, setState) {
      imageWidgetSetState = setState;
      if (thumbnailPath == null) return loadingWidget(0.1);

      return Stack(
        alignment: Alignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 150),
            child: MyImage(
              borderRadius: BorderRadius.circular(7),
              image: MemoryImage(thumbnailPath!),
              fit: BoxFit.cover,
              loadingBuilder: (_, child, loading) {
                return loading == null ? child : loadingWidget(loading.expectedTotalBytes == null ? 0 : loading.cumulativeBytesLoaded / loading.expectedTotalBytes!);
              },
            ),
          ),
          if (thumbnailPath != null)
            InkWell(
              onTap: () => push(context, VideoScreen(videoUrl: videoUrl, attemptOffline: true)),
              child: Container(
                width: 35,
                height: 35,
                padding: EdgeInsets.all(2),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(Icons.play_arrow_rounded, color: isForMe() ? Colors.white : Colors.white),
              ),
            ),
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Colors.black54,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder(
                        bloc: downloadFileBloc,
                        builder: (context, state) {
                          var len = "${widget.fileMessages[0].fileSize ?? '??'}";

                          if (state is DownloadFileLoading) {
                            len = "${state.now.toFileSize(unit: false)}/" + len;
                          }

                          return Text(
                            len,
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "sans-serif",
                              fontWeight: FontWeight.w500,
                              fontSize: 8,
                            ),
                          );
                        },
                      ),
                      FutureBuilder<VideoPlayerValue>(
                        future: getVideoInfo(videoUrl),
                        builder: (context, snapshot) {
                          return Text(
                            timeFormatter(snapshot.data?.duration.inSeconds ?? 0, hasHour: true),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "sans-serif",
                              fontWeight: FontWeight.w500,
                              fontSize: 8,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  BlocBuilder(
                    bloc: downloadFileBloc,
                    builder: (context, state) {
                      if (state is DownloadFileLoading) return loadingProgressWidget(radius: 7.5, progress: 0.7, width: 1.75);
                      if (state is DownloadFileSuccess || widget.files.isFill())
                        return Icon(
                          Icons.play_arrow_rounded,
                          color: isForMe() ? Colors.white : Colors.white,
                          size: 20,
                        );
                      return InkWell(
                        onTap: onClickDownload,
                        child: Icon(
                          Icons.arrow_downward_rounded,
                          color: isForMe() ? Colors.white : Colors.white,
                          size: 18,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget loadingWidget(double progress) {
    return Container(
      height: 150,
      decoration: BoxDecoration(color: isForMe() ? Colors.white12 : Colors.grey.shade50, borderRadius: BorderRadius.circular(5)),
      alignment: Alignment.center,
      child: loadingProgressWidget(radius: 15, progress: progress),
    );
  }

  Widget loadingProgressWidget({required double radius, required double progress, double width = 3}) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(loadingController),
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: isForMe() ? Colors.white24 : Colors.grey.shade200,
        ),
        child: CircularPercentIndicator(
          radius: radius,
          backgroundColor: Colors.transparent,
          percent: progress,
          animation: false,
          lineWidth: width,
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: isForMe() ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  void onClickDownload() {
    downloadFileBloc.add(DownloadFileRequest(widget.fileMessages[0]));
  }

  Future<VideoPlayerValue> getVideoInfo(String videoUrl) async {
    var con = VideoPlayerController.network(videoUrl);
    return await con.value;
  }
}
