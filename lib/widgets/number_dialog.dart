import 'package:flutter/material.dart';
import 'package:siraf3/widgets/text_field_2.dart';

import '../themes.dart';

class NumberDialog extends StatefulWidget {
  @override
  State<NumberDialog> createState() => _NumberDialog();

  TextEditingController numberFieldController;
  String? hintText;
  Function(String)? onChanged;
  Function()? onPressed;

  NumberDialog({required this.numberFieldController, this.hintText = null, this.onChanged, this.onPressed});
}

class _NumberDialog extends State<NumberDialog> {
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
                      keyboardType: TextInputType.number,
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
