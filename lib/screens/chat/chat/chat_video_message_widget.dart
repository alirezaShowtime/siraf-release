import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:siraf3/models/chat_message.dart';
import 'package:siraf3/widgets/my_image.dart';

import 'abstract_message_widget.dart';

class ChatVideoMessageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChatVideoMessageWidget();

  ChatMessage message;

  ChatVideoMessageWidget({
    required this.message,
  });
}

class _ChatVideoMessageWidget extends AbstractMessageWidget<ChatVideoMessageWidget> with TickerProviderStateMixin {
  late AnimationController loadingController;
  bool isSeen = false;

  @override
  ChatMessage? messageForReply() => widget.message;

  @override
  bool isForMe() => widget.message.forMe;

  @override
  Widget content() {
    return onlyImage();
    // return widget.message.message != null ? withMessage() : onlyImage();
  }

  @override
  void initState() {
    super.initState();

    loadingController = AnimationController(vsync: this, duration: Duration(milliseconds: 700));
  }

  // Widget withMessage() {}

  Widget onlyImage() {
    return Stack(
      children: [
        StaggeredGrid.count(
          crossAxisCount: _getCount(),
          crossAxisSpacing: 2,
          children: [
            for (ChatFileMessage file in widget.message.fileMessages!)
              MyImage(
                borderRadius: BorderRadius.circular(16),
                // image: NetworkImage(widget.message.fileMessages![0].path!),
                image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR8V-j5FFQozdzkIojXSu1IkjruUuXq3RIriePp-A6Xm7wOdGlhagfIi-5nqUHYxm_Df88&usqp=CAU"),
                fit: BoxFit.cover,
                // loadingBuilder: (_, widget, progress) {
                //   if (progress == null) widget;
                //   return Container(
                //     color: isForMe() ? Colors.white24 : Colors.grey.shade100,
                //     alignment: Alignment.center,
                //     child: RotationTransition(
                //       turns: Tween(begin: 0.0, end: 1.0).animate(loadingController),
                //       child: CircularPercentIndicator(
                //         radius: 15,
                //         backgroundColor: Colors.transparent,
                //         percent: 0.6,
                //         animation: true,
                //         lineWidth: 3.5,
                //         circularStrokeCap: CircularStrokeCap.round,
                //         progressColor: isForMe() ? Colors.black : Colors.black,
                //       ),
                //     ),
                //   );
                // },
              ),
          ],
        ),
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
                  "12:44",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    fontFamily: "sans-serif"
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  int _getCount() {

    switch(widget.message.fileMessages!.length){

      case 1 : return 1;
      case 2 : return 1;
      case 3 : return 1;
      case 4 : return 1;
      case 5 : return 2;
      case 5 : return 2;
      case 6 : return 2;
      case 7 : return 2;


    }



  }
}
