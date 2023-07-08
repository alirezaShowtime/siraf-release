import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:siraf3/controller/chat_message_upload_controller.dart';
import 'package:siraf3/enums/message_state.dart';
import 'package:siraf3/extensions/string_extension.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/screens/image_view_screen.dart';
import 'package:siraf3/widgets/my_image.dart';

import 'chat_sending_message_widget.dart';

class ChatSendingImageMessageWidgetState extends ChatSendingMessageWidgetState {
  late AnimationController loadingController;
  bool isSeen = false;

  @override
  double maxWidth() {
    return MediaQuery.of(context).size.width * 0.55;
  }

  @override
  Widget content() {
    return widget.message.isFill() ? withMessage() : onlyImage();
  }

  @override
  void initState() {
    super.initState();

    loadingController = AnimationController(vsync: this, duration: Duration(milliseconds: 1700))..repeat(reverse: false);
  }

  @override
  void dispose() {
    loadingController.dispose();
    super.dispose();
  }

  Widget withMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        replyWidget(widget.replyMessage, widget.onClickReplyMessage),
        _imageView(),
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
            }),
      ],
    );
  }

  Widget onlyImage() {
    return Column(
      children: [
        replyWidget(widget.replyMessage, widget.onClickReplyMessage),
        Stack(
          children: [
            _imageView(),
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

  Widget _imageView() {
    return Stack(
      alignment: Alignment.center,
      children: [
        MyImage(
          borderRadius: BorderRadius.circular(7),
          image: FileImage(widget.files![0]),
          fit: BoxFit.fitWidth,
          errorWidget: Container(
            color: isForMe() ? Colors.white12 : Colors.grey.shade100,
            alignment: Alignment.center,
            height: 120,
            child: Container(
              width: 32,
              height: 32,
              padding: EdgeInsets.only(bottom: 2.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white24,
              ),
              child: Icon(Icons.warning_amber_rounded, color: Colors.white),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: ColoredBox(color: Colors.black12),
        ),
        StreamBuilder<UploadingDetail>(
          initialData: UploadingDetail(0, 0),
          stream: widget.controller.uploading.stream,
          builder: (context, snapshot) {
            if ((snapshot.data?.percent ?? 0) == 100) return SizedBox();
            return loadingProgressWidget(radius: 15, progress: snapshot.data?.percent ?? 0);
          },
        ),
      ],
    );
    return StaggeredGrid.count(
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      crossAxisCount: 2,
      children: [
        for (var i = 0; i < widget.files!.length; i++)
          StaggeredGridTile.count(
            mainAxisCellCount: 1,
            crossAxisCellCount: i == widget.files!.length - 1 && i.isEven ? 2 : 1,
            child: InkWell(
              onTap: () => push(context, ImageViewScreen(imageFile: widget.files![i])),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  MyImage(
                    borderRadius: BorderRadius.circular(3),
                    image: FileImage(widget.files![i]),
                    fit: BoxFit.fitWidth,
                    errorWidget: Container(
                      color: isForMe() ? Colors.white12 : Colors.grey.shade100,
                      alignment: Alignment.center,
                      child: Container(
                        width: 32,
                        height: 32,
                        padding: EdgeInsets.only(bottom: 2.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white24,
                        ),
                        child: Icon(Icons.warning_amber_rounded, color: Colors.white),
                      ),
                    ),
                  ),
                  StreamBuilder<UploadingDetail>(
                    initialData: UploadingDetail(0, 0),
                    stream: widget.controller.uploading.stream,
                    builder: (context, snapshot) {
                      if ((snapshot.data?.percent ?? 0) == 100) return SizedBox();
                      return loadingProgressWidget(radius: 15, progress: snapshot.data?.percent ?? 0);
                    },
                  ),
                ],
              ),
            ),
          ),
      ],
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
