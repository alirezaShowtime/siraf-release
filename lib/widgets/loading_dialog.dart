import 'package:flutter/material.dart';
import 'package:siraf3/widgets/loading.dart';

class LoadingDialog extends StatefulWidget {
  String? message;
  LoadingDialog({this.message, super.key});

  @override
  State<LoadingDialog> createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      content: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 170,
        child: Column(
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
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Loading(),
          ],
        ),
      ),
    );
  }
}
