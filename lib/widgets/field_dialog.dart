import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../themes.dart';

class FieldDialog extends StatefulWidget {
  @override
  State<FieldDialog> createState() => _FieldDialog();

  TextEditingController numberFieldController;
  String? hintText;
  Function(String)? onChanged;
  Function()? onPressed;
  TextInputType? keyboardType;
  List<TextInputFormatter>? inputFormatters;
  String? helperSuffix;

  FieldDialog({
    required this.numberFieldController,
    this.hintText = null,
    this.onChanged,
    this.onPressed,
    this.inputFormatters,
    this.keyboardType,
    this.helperSuffix,
  });
}

class _FieldDialog extends State<FieldDialog> {
  StreamController<String> numberStream = StreamController();


  @override
  void initState() {
    super.initState();

    numberStream.add(widget.numberFieldController.text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Wrap(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    height: 30,
                    alignment: Alignment.center,
                    child: TextField2(
                      maxLines: 1,
                      controller: widget.numberFieldController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: widget.hintText,
                        hintStyle: TextStyle(
                          color: App.theme.tooltipTheme.textStyle?.color,
                          fontSize: 13,
                          fontFamily: "IranSans",
                        ),
                      ),
                      inputFormatters: widget.inputFormatters,
                      style: TextStyle(
                        color: App.theme.textTheme.bodyLarge?.color,
                        fontSize: 13,
                        fontFamily: "IranSansMedium",
                      ),
                      onChanged: (v) {
                        numberStream.add(v);

                        widget.onChanged?.call(v);
                      },
                      keyboardType: widget.keyboardType,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                StreamBuilder<String>(
                  stream: numberStream.stream,
                  builder: (context, snapshot) {
                    var text = "";

                    if (snapshot.hasData) {
                      text = (snapshot.data != null ? snapshot.data!.toWord() : "");
                      if (text.trim().isNotEmpty) {
                        text = text + " ${widget.helperSuffix ?? ""}";
                        text = text.trim();
                      }
                    }

                    return Container(
                      alignment: Alignment.center,
                      height: 20,
                      child: Text(
                        text,
                        style: TextStyle(
                          color: App.theme.textTheme.bodyLarge?.color,
                          fontSize: 11,
                          fontFamily: "IranSansMedium",
                        ),
                      ),
                    );
                  }
                ),
                MaterialButton(
                  onPressed: () {
                    if (widget.onPressed != null) {
                      widget.onPressed!();
                    }
                    Navigator.pop(context);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  color: App.theme.primaryColor,
                  elevation: 1,
                  height: 50,
                  minWidth: double.infinity,
                  child: Text(
                    "تایید",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "IranSansBold",
                      fontSize: 14,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 9),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
