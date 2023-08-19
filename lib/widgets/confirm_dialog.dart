import 'package:flutter/material.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/widgets/dialog_button.dart';

class ConfirmDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ConfirmDialog();

  String content;
  String? title;
  String applyText;
  String cancelText;
  void Function()? onCancel;
  void Function()? onApply;
  Color? titleColor;

  BuildContext dialogContext;

  ConfirmDialog({required this.dialogContext, required this.content, this.title, this.onApply, this.onCancel, this.applyText = "تایید", this.cancelText = "لغو", this.titleColor});
}

class _ConfirmDialog extends State<ConfirmDialog> {
  @override
  void initState() {
    super.initState();
    dialogContext = widget.dialogContext;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10),
          if (widget.title != null)
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              alignment: Alignment.topRight,
              child: Text(
                widget.title!,
                style: TextStyle(
                  color: widget.titleColor ?? App.theme.textTheme.bodyLarge?.color,
                  fontFamily: "IranSansBold",
                  fontSize: 16,
                ),
              ),
            ),
          SizedBox(height: 10),
          Container(
            constraints: BoxConstraints(minHeight: 50),
            padding: const EdgeInsets.only(left: 15, right: 25),
            alignment: Alignment.topRight,
            child: Text(
              widget.content,
              style: TextStyle(color: App.theme.textTheme.bodyLarge?.color, fontSize: 12.5),
            ),
          ),
          SizedBox(height: 15),
          SizedBox(height: 1.7),
          ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
            child: ColoredBox(
              color: App.theme.primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DialogButton(
                      labelText: widget.applyText,
                      onPressed: widget.onApply,
                    ),
                  ),
                  Container(
                    width: 0.5,
                    height: 55,
                    color: Colors.white,
                  ),
                  Expanded(
                    child: DialogButton(
                      labelText: widget.cancelText,
                      onPressed: () {
                        widget.onCancel?.call();
                        dismissDialog(context);
                      },
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
