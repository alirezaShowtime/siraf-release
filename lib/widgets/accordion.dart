import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/widgets/my_icon_button.dart';

class Accordion extends StatefulWidget {
  final Widget title;
  Widget? content;
  bool? open;
  Function? onClick;
  Color? backgroundColor;
  bool hasBadge;

  Accordion({
    Key? key,
    required this.title,
    this.content,
    this.open,
    this.onClick,
    this.hasBadge = false,
    this.backgroundColor,
  }) : super(key: key);

  @override
  _AccordionState createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.backgroundColor ?? App.theme.dialogBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.only(bottom: 5),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: _onClick,
            borderRadius: BorderRadius.circular(5),
            child: Container(
              constraints: BoxConstraints(minHeight: 50),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.hasBadge
                      ? badge.Badge(
                          badgeContent: Text(''),
                          showBadge: true,
                          position: badge.BadgePosition.custom(top: -12, start: 1),
                          badgeStyle: badge.BadgeStyle(badgeColor: App.theme.primaryColor),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 7, top: 7, right: 12),
                            child: widget.title,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(bottom: 7, top: 7, right: 7),
                          child: widget.title,
                        ),
                  if (widget.open != null)
                    MyIconButton(
                      onTap: _onClick,
                      iconData: widget.open! ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    ),
                ],
              ),
            ),
          ),
          widget.open == true ? Padding(padding: const EdgeInsets.only(bottom: 9), child: widget.content) : Container()
        ],
      ),
    );
  }

  void _onClick() {
    if (widget.onClick != null) {
      widget.onClick!();
    }

    if (widget.open != null) {
      setState(() {
        widget.open = !widget.open!;
      });
    }
  }
}

class AccordionItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccordionItem();

  String title;
  GestureTapCallback onClick;
  bool hasBadge;

  AccordionItem({required this.onClick, required this.title, this.hasBadge = true});
}

class _AccordionItem extends State<AccordionItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onClick,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 12, bottom: 12, right: (widget.hasBadge ? 22 : 20)),
        child: badge.Badge(
          badgeContent: Text(''),
          showBadge: widget.hasBadge,
          position: badge.BadgePosition.custom(top: -15, start: -15),
          badgeStyle: badge.BadgeStyle(badgeColor: App.theme.primaryColor),
          child: Text(
            widget.title,
            style: TextStyle(fontSize: 10, fontFamily: "IranSansMedium"),
          ),
        ),
      ),
    );
  }
}
