import 'package:siraf3/main.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/icon_asset.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badge;

class Accordion extends StatefulWidget {
  final Widget title;
  final Widget content;
  bool open;
  Function? onClick;
  Color? backgroundColor;
  bool hasBadge;

  Accordion({
    Key? key,
    required this.title,
    required this.content,
    this.open = false,
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: widget.backgroundColor ?? App.theme.dialogBackgroundColor,
      ),
      margin: EdgeInsets.only(bottom: 5),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: _onClick,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                // color: widget.backgroundColor ?? App.theme.dialogBackgroundColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.hasBadge
                      ? badge.Badge(
                          badgeContent: Text(''),
                          showBadge: true,
                          position:
                              badge.BadgePosition.custom(top: -12, start: 1),
                          badgeStyle:
                              badge.BadgeStyle(badgeColor: App.theme.primaryColor),
                          child: Padding(
                            padding:
                                EdgeInsets.only(bottom: 7, top: 7, right: 12),
                            child: widget.title,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(bottom: 7, top: 7, right: 7),
                          child: widget.title,
                        ),
                  IconAsset(
                    icon: widget.open
                        ? "ic_arrow_top.png"
                        : "ic_arrow_bottom.png",
                    width: 14,
                    height: 8,
                    color: App.theme.iconTheme.color,
                    fit: BoxFit.fill,
                    onPressed: _onClick,
                  ),
                ],
              ),
            ),
          ),
          widget.open
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: widget.content)
              : Container()
        ],
      ),
    );
  }

  void _onClick() {
    if (widget.onClick != null) {
      widget.onClick!();
    }

    setState(() {
      widget.open = !widget.open;
    });
  }
}

class AccordionItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccordionItem();

  String title;
  GestureTapCallback onClick;
  bool hasBadge;

  AccordionItem({required this.onClick, required this.title, this.hasBadge = false});
}

class _AccordionItem extends State<AccordionItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onClick,
      radius: 15,
      child: badge.Badge(
        badgeContent: Text(''),
        showBadge: widget.hasBadge,
        position: badge.BadgePosition.custom(top: -12, start: 5),
        badgeStyle: badge.BadgeStyle(badgeColor: App.theme.primaryColor),
        child: Padding(
          padding: EdgeInsets.only(
              top: 5, bottom: 5, right: (widget.hasBadge ? 18 : 10)),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
