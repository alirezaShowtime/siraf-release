import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/material.dart';
import 'package:siraf3/screens/ticket/chat/massage_action.dart';
import 'package:siraf3/themes.dart';

class PersonMessage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PersonMessage();

  Widget? child;
  String? text;
  String time;
  bool isFirst;

  PersonMessage({
    required this.time,
    this.child,
    this.text,
    this.isFirst = false,
  });
}

class _PersonMessage extends State<PersonMessage> {
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
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(18),
            topLeft: Radius.circular(widget.isFirst ? 14 : 5),
            bottomRight: Radius.circular(18),
            bottomLeft: Radius.circular(0),
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
                            color: Themes.text,
                            fontSize: 12,
                          ),
                        ),
                      ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2, right: 2, top: 4),
              child: Text(
                widget.time,
                style: TextStyle(color: Themes.text, fontSize: 9, height: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
