import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/screens/chat/chat/messageWidgets/chat_message_widget.dart';
import 'package:siraf3/screens/image_view_screen.dart';
import 'package:siraf3/widgets/my_image.dart';

class ChatImageMessageWidgetState extends ChatMessageWidgetState {
  late AnimationController loadingController;

  @override
  Widget content() {
    return widget.message.message != null ? withMessage() : onlyImage();
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
        replyWidget(widget.message.replyMessage, widget.onClickReplyMessage),
        _imageView(),
        textWidget(widget.message.message),
        footerWidget(false, widget.message.createTime!),
      ],
    );
  }

  Widget onlyImage() {
    return Column(
      children: [
        replyWidget(widget.message.replyMessage, widget.onClickReplyMessage),
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

  Widget _imageView() {
    return StaggeredGrid.count(
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      crossAxisCount: 2,
      children: [
        for (var i = 0; i < widget.fileMessages.length; i++)
          StaggeredGridTile.count(
            mainAxisCellCount: 1,
            crossAxisCellCount: i == widget.fileMessages.length - 1 && i.isEven ? 2 : 1,
            child: InkWell(
              onTap: () => push(context, ImageViewScreen(imageUrl: widget.fileMessages[i].path!)),
              child: MyImage(
                borderRadius: BorderRadius.circular(3),
                image: CachedNetworkImageProvider(widget.fileMessages[i].path!),
                fit: BoxFit.cover,
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
                loadingBuilder: (_, child, loading) {
                  if (loading == null) return child;
                  return Container(
                    color: isForMe() ? Colors.white12 : Colors.grey.shade100,
                    alignment: Alignment.center,
                    child: RotationTransition(
                      turns: Tween(begin: 0.0, end: 1.0).animate(loadingController),
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white24,
                        ),
                        child: CircularPercentIndicator(
                          radius: 15,
                          backgroundColor: Colors.transparent,
                          percent: loading.expectedTotalBytes == null ? 0.6 : loading.cumulativeBytesLoaded / loading.expectedTotalBytes!,
                          animation: true,
                          lineWidth: 3.5,
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: isForMe() ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
