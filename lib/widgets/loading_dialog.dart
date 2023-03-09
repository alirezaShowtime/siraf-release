import 'package:flutter/material.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/main.dart';

class LoadingDialog extends StatefulWidget {
  String? message;
  bool showMessage;
  LoadingDialog({this.message, this.showMessage = true, super.key});

  @override
  State<LoadingDialog> createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: widget.showMessage
            ? 0
            : (MediaQuery.of(context).size.width - 100) / 2,
      ),
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        height: widget.showMessage ? 170 : 100,
        alignment: Alignment.center,
        child: widget.showMessage
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      widget.message ?? 'در حال ارسال درخواست صبور باشید',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Loading(),
                ],
              )
            : Loading(),
      ),
    );
  }
}
