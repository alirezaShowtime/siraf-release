import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/icon_asset.dart';

class Accordion extends StatefulWidget {
  final Widget title;
  final Widget content;
  bool open;
  Function? onClick;
  Function(bool value)? onChanged;

  Accordion({
    Key? key,
    required this.title,
    required this.content,
    this.open = false,
    this.onClick,
    this.onChanged,
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
        color: Themes.background2,
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
                color: Themes.background2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 7, top: 7, right: 7),
                    child: widget.title,
                  ),
                  IconAsset(
                    icon: widget.open ? "ic_arrow_top.png" : "ic_arrow_bottom.png",
                    width: 14,
                    height: 8,
                    color: Themes.icon,
                    fit: BoxFit.fill,
                    onPressed: _onClick,
                  ),
                ],
              ),
            ),
          ),
          widget.open ? Padding(padding: const EdgeInsets.only(bottom: 9), child: widget.content) : Container()
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

    if (widget.onChanged != null) {
      widget.onChanged!(widget.open);
    }
  }
}

class AccordionItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccordionItem();

  String title;
  GestureTapCallback onClick;

  AccordionItem({required this.onClick, required this.title});
}

class _AccordionItem extends State<AccordionItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onClick,
      radius: 15,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Text(
          widget.title,
          style: TextStyle(
            fontSize: 12,
            color: Themes.text,
          ),
        ),
      ),
    );
  }
}
