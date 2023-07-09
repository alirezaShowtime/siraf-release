import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/loading.dart';

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
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.zero,
        content: !widget.showMessage
            ? Loading()
            : Container(
                height: 85,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Themes.primary),
                    SizedBox(width: 18),
                    Expanded(
                      child: Text(
                        widget.message ?? 'در حال ارسال درخواست صبور باشید',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Themes.text,
                          fontSize: 11,
                          fontFamily: "IranSansBold",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
