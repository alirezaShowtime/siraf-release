import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:siraf3/controller/chat_message_upload_controller.dart';
import 'package:siraf3/enums/message_state.dart';
import 'package:siraf3/extensions/int_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/screens/chat/chat/sendingMessageWidgets/chat_sending_message_widget.dart';
import 'package:siraf3/screens/video_screen.dart';
import 'package:siraf3/widgets/my_image.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ChatSendingVideoMessageWidgetState extends ChatSendingMessageWidgetState {
  late AnimationController loadingController;

  late Future<Uint8List?> videoThumbnail;
  bool isSeen = false;
  late Future<VideoPlayerValue> infoVideo;

  late File videoFile;

  @override
  void initState() {
    super.initState();

    videoFile = widget.files!.first;

    loadingController = AnimationController(vsync: this, duration: Duration(milliseconds: 1700))..repeat(reverse: false);

    videoThumbnail = getVideoThumbnail(videoFile.path);

    infoVideo = getVideoInfo(videoFile);
  }

  @override
  void dispose() {
    loadingController.dispose();
    super.dispose();
  }

  Future<Uint8List?> getVideoThumbnail(String videoUrl) {
    return VideoThumbnail.thumbnailData(
      video: videoUrl,
      imageFormat: ImageFormat.WEBP,
    );
  }

  @override
  Widget content() {
    return widget.message == null ? onlyVideo() : withText();
  }

  Widget onlyVideo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        replyWidget(widget.replyMessage, widget.onClickReplyMessage),
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
                child: StreamBuilder<MessageState>(
                  initialData: MessageState.Uploading,
                  stream: widget.controller.messageSate.stream,
                  builder: (context, snapshot) {
                    return Row(
                      children: [
                        if (snapshot.data == MessageState.Uploading)
                          Icon(
                            Icons.schedule_rounded,
                            color: Colors.white,
                            size: 13,
                          ),
                        if (snapshot.data == MessageState.ErrorUpload)
                          Icon(
                            Icons.error_rounded,
                            color: Colors.red,
                            size: 13,
                          ),
                        SizedBox(width: 4),
                        Text(
                          createTime ?? "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            fontFamily: "sans-serif",
                          ),
                        ),
                      ],
                    );
                  },
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
        replyWidget(widget.replyMessage, widget.onClickReplyMessage),
        videoWidget(),
        textWidget(widget.message),
        StreamBuilder<MessageState>(
          initialData: MessageState.Uploading,
          stream: widget.controller.messageSate.stream,
          builder: (context, snapshot) {
            return footerWidget(
              false,
              createTime ?? "",
              error: snapshot.data == MessageState.ErrorUpload,
              sending: snapshot.data == MessageState.Uploading,
            );
          },
        ),
      ],
    );
  }

  Widget videoWidget() {
    return Stack(
      alignment: Alignment.center,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 150),
          child: FutureBuilder<Uint8List?>(
            future: videoThumbnail,
            builder: (context, snapshot) {
              if (snapshot.data == null) return loadingWidget(0.1);

              return MyImage(
                borderRadius: BorderRadius.circular(7),
                image: MemoryImage(snapshot.data!),
                fit: BoxFit.cover,
                loadingBuilder: (_, child, loading) {
                  return loading == null ? child : loadingWidget(loading.expectedTotalBytes == null ? 0 : loading.cumulativeBytesLoaded / loading.expectedTotalBytes!);
                },
              );
            },
          ),
        ),
        StreamBuilder<MessageState>(
          initialData: MessageState.Uploading,
          stream: widget.controller.messageSate.stream,
          builder: (context, snapshot) {
            if (snapshot.data != MessageState.Uploading) return playBtn();
            return StreamBuilder<UploadingDetail>(
              initialData: UploadingDetail(0, 0),
              stream: widget.controller.uploading.stream,
              builder: (context, snapshot) {
                return loadingProgressWidget(radius: 15, progress: snapshot.data!.percent.toDouble());
              },
            );
          },
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
                    StreamBuilder<UploadingDetail>(
                      initialData: UploadingDetail(0, 0),
                      stream: widget.controller.uploading.stream,
                      builder: (context, snapshot) {
                        var detail = snapshot.data!;
                        return Text(
                          "${detail.uploaded.toFileSize(unit: false)}/${detail.count.toFileSize()}",
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
                      future: infoVideo,
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
                StreamBuilder(
                  stream: widget.controller.messageSate.stream,
                  builder: (context, snapshot) {
                    switch (snapshot.data) {
                      case MessageState.Uploaded:
                        return Icon(
                          Icons.play_arrow_rounded,
                          color: isForMe() ? Colors.white : Colors.white,
                          size: 20,
                        );
                      case MessageState.ErrorUpload:
                        return Icon(
                          Icons.warning_amber_rounded,
                          color: isForMe() ? Colors.white : Colors.white,
                          size: 20,
                        );
                      default:
                        return Icon(
                          Icons.arrow_upward_rounded,
                          color: isForMe() ? Colors.white : Colors.white,
                          size: 18,
                        );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget loadingWidget(double progress) {
    return Container(
      height: 150,
      width: double.infinity,
      color: isForMe() ? Colors.white12 : Colors.grey.shade100,
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
          color: Colors.white24,
        ),
        child: CircularPercentIndicator(
          radius: radius,
          backgroundColor: Colors.transparent,
          percent: progress,
          animation: true,
          lineWidth: width,
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: isForMe() ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Future<VideoPlayerValue> getVideoInfo(File videoFile) async {
    return await VideoPlayerController.file(videoFile).value;
  }

  Widget playBtn() {
    return InkWell(
      onTap: () => push(context, VideoScreen(videoFile: videoFile)),
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
    );
  }
}
