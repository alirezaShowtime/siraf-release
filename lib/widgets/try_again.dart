import 'package:flutter/material.dart';
import 'package:siraf3/main.dart';

class TryAgain extends StatefulWidget {
  void Function()? onPressed;
  String? message;

  TryAgain({super.key, this.onPressed, this.message});

  @override
  State<TryAgain> createState() => _TryAgainState();
}

class _TryAgainState extends State<TryAgain> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.message ?? "خطایی در هنگام دریافت اطلاعات پیش آمد",
          style: TextStyle(
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10,
        ),
        if (widget.onPressed != null) RawMaterialButton(
          onPressed: widget.onPressed,
          child: Text(
            "تلاش مجدد",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          elevation: 0.2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          fillColor: App.theme.primaryColor,
        )
      ],
    );
  }
}
