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

  void Function(void Function())? imageWidgetSetState;
  Uint8List? thumbnailPath;
  bool isSeen = false;
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();

    loadingController = AnimationController(vsync: this, duration: Duration(milliseconds: 1700))..repeat(reverse: false);

    getVideoThumbnail(widget.files!.first.path);

    videoPlayerController = VideoPlayerController.file(widget.files!.first);
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
                child: Row(
                  children: [
                    if (isForMe())
                      Icon(
                        isSeen ? Icons.done_all_rounded : Icons.check_rounded,
                        color: isForMe() ? Colors.white : Colors.red,
                        size: 13,
                      ),
                    SizedBox(width: 4),
                    Text(
                      widget.controller.getCreateTime() ?? "",
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
        replyWidget(widget.replyMessage, widget.onClickReplyMessage),
        videoWidget(),
        textWidget(widget.message),
        footerWidget(false, widget.controller.getCreateTime() ?? ""),
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
          StreamBuilder<UploadingDetail>(
              initialData: UploadingDetail(0, 0),
              stream: widget.controller.uploading.stream,
              builder: (context, snapshot) {
                var detail = snapshot.data!;

                if (detail.percent < 99) {
                  return loadingProgressWidget(radius: 15, progress: detail.percent.toDouble());
                }

                return InkWell(
                  onTap: () => push(context, VideoScreen(videoFile: widget.files!.first)),
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
              }),
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
                              "${detail.count.toFileSize(unit: false)}/${detail.count.toFileSize()}",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "sans-serif",
                                fontWeight: FontWeight.w500,
                                fontSize: 8,
                              ),
                            );
                          }),
                      Text(
                        timeFormatter(videoPlayerController.value.duration.inSeconds, hasHour: true),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "sans-serif",
                          fontWeight: FontWeight.w500,
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                  StreamBuilder(
                    stream: widget.controller.messageSate.stream,
                    builder: (context, snapshot) {
                      if (snapshot.data == MessageState.Uploading)
                        return Icon(
                          Icons.arrow_upward_rounded,
                          color: isForMe() ? Colors.white : Colors.white,
                          size: 18,
                        );
                      if (snapshot.data == MessageState.Uploaded)
                        return Icon(
                          Icons.play_arrow_rounded,
                          color: isForMe() ? Colors.white : Colors.white,
                          size: 20,
                        );
                      if (snapshot.data == MessageState.ErrorUpload)
                        return Icon(
                          Icons.warning_amber_rounded,
                          color: isForMe() ? Colors.white : Colors.white,
                          size: 20,
                        );
                      return Icon(
                        Icons.arrow_upward_rounded,
                        color: isForMe() ? Colors.white : Colors.white,
                        size: 18,
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
}
