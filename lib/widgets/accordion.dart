import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/icon_asset.dart';

class Accordion extends StatefulWidget {
  final Widget title;
  final Widget content;
  bool open;
  Function? onClick;

  Accordion({
    Key? key,
    required this.title,
    required this.content,
    this.open = false,
    this.onClick,
  }) : super(key: key);

  @override
  _AccordionState createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.3,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: GestureDetector(onTap: _onClick, child: widget.title),
            trailing: IconAsset(
              icon: widget.open ? "ic_arrow_top.png" : "ic_arrow_bottom.png",
              width: 14,
              height: 8,
              color: Themes.icon,
              fit: BoxFit.fill,
              onPressed: _onClick,
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
            color: Colors.grey.shade500,
          ),
        ),
      ),
    );
  }
}
