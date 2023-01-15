import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:siraf3/themes.dart';

class Loading extends StatefulWidget {
  var color;
  var size;

  Loading({this.color = Themes.primary, this.size = 50.0});
  @override
  State<Loading> createState() => __LoadingState();
}

class __LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return SpinKitDualRing(size: widget.size, color: widget.color);
  }
}
