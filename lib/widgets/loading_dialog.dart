import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_text_button.dart';

class LoadingDialog extends StatefulWidget {
  String? message;
  bool showMessage;
  void Function()? onClickCancel;

  LoadingDialog({this.message, this.showMessage = true, this.onClickCancel, super.key});

  @override
  State<LoadingDialog> createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  @override
  Widget build(BuildContext context) {
    if (!widget.showMessage) return SizedBox(width: 85, height: 85, child: onlyLoading());

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.zero,
        content: !widget.showMessage ? SizedBox(width: 85, height: 85, child: onlyLoading()) : withText(),
      ),
    );
  }

  Widget withText() {
    if (widget.onClickCancel == null) {
      return Container(
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
      );
    }

    return Container(
      height: 85,
      alignment: Alignment.center,
      padding: EdgeInsets.only(right: 18, left: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Themes.primary),
          SizedBox(width: 18),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.message ?? 'در حال ارسال درخواست صبور باشید',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Themes.text,
                      fontSize: 11,
                      fontFamily: "IranSansBold",
                    ),
                  ),
                  SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MyTextButton(
                        border: true,
                        text: "لغو",
                        fontSize: 10,
                        minimumSize: Size(55, 30),
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: widget.onClickCancel,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget onlyLoading() {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: widget.onClickCancel == null
            ? Loading()
            : Container(
                height: 130,
                width: 110,
                padding: EdgeInsets.only(top: 20, bottom: 10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 50, width: 50, child: CircularProgressIndicator(color: Themes.primary)),
                    MyTextButton(
                      border: true,
                      text: "لغو",
                      fontSize: 10,
                      textColor: Colors.red,
                      onPressed: widget.onClickCancel,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
