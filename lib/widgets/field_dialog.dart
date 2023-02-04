import 'package:flutter/material.dart';
import 'package:siraf3/widgets/text_field_2.dart';

import '../themes.dart';

class FieldDialog extends StatefulWidget {
  @override
  State<FieldDialog> createState() => _FieldDialog();

  TextEditingController numberFieldController;
  String? hintText;
  Function(String)? onChanged;
  Function()? onPressed;
  TextInputType? keyboardType;

  FieldDialog({required this.numberFieldController, this.hintText = null, this.onChanged, this.onPressed, this.keyboardType});
}

class _FieldDialog extends State<FieldDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.5),
      ),
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Wrap(
          children: [
            Column(
              children: [
                SizedBox(height: 20),
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
                        hintStyle: TextStyle(color: Colors.grey.shade300),
                      ),
                      onChanged: widget.onChanged,
                      keyboardType: widget.keyboardType,
                      textAlign: TextAlign.center,
                    ),
                  ),
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
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                  color: Themes.primary,
                  elevation: 1,
                  height: 50,
                  minWidth: double.infinity,
                  child: Text(
                    "تایید",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
