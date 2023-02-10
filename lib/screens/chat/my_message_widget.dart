import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/material.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/screens/chat/massage_action.dart';
import 'package:siraf3/themes.dart';

class MyMessage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyMessage();

  Widget? child;
  String? text;
  String time;
  bool isSeen;
  bool isFirst;
  bool isSent;

  MyMessage({
    required this.time,
    this.child,
    this.text,
    this.isSeen = false,
    this.isFirst = false,
    this.isSent = true,
  });
}

class _MyMessage extends State<MyMessage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        showMessageActionMenu(
          context,
          details,
          onClickDeleteItem: () {},
          onClickAnswerItem: () {},
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2),
        padding: EdgeInsets.only(top: 7, left: 10, right: 10, bottom: 4),
        decoration: BoxDecoration(
          color: Themes.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(widget.isFirst ? 14 : 5),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  child: widget.child ??
                      AutoDirection(
                        text: widget.text!,
                        child: Text(
                          widget.text!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (widget.isSent)
                  icon(
                    widget.isSeen ? Icons.done_all_rounded : Icons.done_rounded,
                    color: Colors.white,
                    size: 12,
                  ),
                if (!widget.isSent)
                  icon(
                    Icons.schedule_rounded,
                    color: Colors.white,
                    size: 12,
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 2, right: 2, top: 4),
                  child: Text(
                    widget.time,
                    style:
                        TextStyle(color: Colors.white, fontSize: 9, height: 1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
