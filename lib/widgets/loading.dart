import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/themes2.dart';

class Loading extends StatefulWidget {
  var color;
  var size;

  Loading({this.color = Themes2.secondary, this.size = 50.0});
  @override
  State<Loading> createState() => __LoadingState();
}

class __LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20)),
      child: SpinKitRing(
        size: widget.size,
        color: widget.color,
        lineWidth: 4,
      ),
    );
  }
}
