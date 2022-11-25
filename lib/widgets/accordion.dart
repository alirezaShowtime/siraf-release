import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/icon_asset.dart';

class Accordion extends StatefulWidget {
  final Widget title;
  final Widget content;

  Accordion({Key? key, required this.title, required this.content})
      : super(key: key);
  @override
  _AccordionState createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  bool _showContent = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(children: [
        ListTile(
          title: GestureDetector(
              onTap: () {
                setState(() {
                  _showContent = !_showContent;
                });
              },
              child: widget.title),
          trailing: IconAsset(
            icon: _showContent ? "ic_arrow_top.png" : "ic_arrow_bottom.png",
            width: 17,
            height: 10,
            color: Themes.primary,
            fit: BoxFit.fill,
            onPressed: () {
              setState(() {
                _showContent = !_showContent;
              });
            },
          ),
        ),
        _showContent ? widget.content : Container()
      ]),
    );
  }
}
