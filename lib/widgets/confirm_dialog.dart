import 'package:flutter/material.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/widgets/dialog_button.dart';

import '../themes.dart';

class ConfirmDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ConfirmDialog();

  String content;
  String? title;
  void Function()? onCancel;
  void Function()? onApply;

  BuildContext dialogContext;

  ConfirmDialog({
    required this.content,
    required this.dialogContext,
    this.title,
    this.onApply,
    this.onCancel,
  });
}

class _ConfirmDialog extends State<ConfirmDialog> {
  @override
  void initState() {
    super.initState();
    //todo
    // dialogContext = widget.dialogContext;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 27),
          if (widget.title != null)
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              alignment: Alignment.topRight,
              child: Text(
                widget.title!,
                style: TextStyle(
                  color: Themes.text,
                  fontWeight: FontWeight.bold,
                  fontFamily: "IRANSansBold",
                  fontSize: 16,
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.only(top: 8, left: 15, right: 25),
            constraints: BoxConstraints(minHeight: 70),
            alignment: Alignment.topRight,
            child: Text(
              widget.content,
              style: TextStyle(color: Themes.textGrey, fontSize: 12),
            ),
          ),
          SizedBox(height: 1.7),
          ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
            child: ColoredBox(
              color: Themes.primary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DialogButton(
                      onPressed: widget.onApply,
                      labelText: "تایید",
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 55,
                    color: Colors.white,
                  ),
                  Expanded(
                    child: DialogButton(
                      onPressed: () {
                        widget.onCancel?.call();
                        dismissDialog(context);
                      },
                      labelText: "لغو",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
