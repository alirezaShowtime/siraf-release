import 'dart:math';

import 'package:flutter/material.dart';
import 'package:siraf3/main.dart';

class MyAudioWave extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAudioWave();

  double progress;
  Color barColor;
  Color? activeBarColor;

  MyAudioWave({
    this.progress = 0.0,
    this.barColor = Colors.white60,
    this.activeBarColor,
  });
}

class _MyAudioWave extends State<MyAudioWave> {
  Random rad = Random();
  List<int> heightBars = [];

  @override
  void initState() {
    super.initState();

    heightBars = [for (int i = 0; i < 45; i++) i > 2 && i < 43 ? rad.nextInt(20) : 2];
  }

  @override
  Widget build(BuildContext context) {
    var activeBar = (widget.progress * heightBars.length).toInt();

    return GestureDetector(
      onHorizontalDragStart: (details) {},
      onHorizontalDragEnd: (details) {},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        textDirection: TextDirection.ltr,
        children: [
          for (int i = 0; i < heightBars.length; i++)
            bar(
              heightBars[i],
              color: i < activeBar ? widget.activeBarColor ?? App.theme.primaryColor : widget.barColor,
            ),
        ],
      ),
    );
  }

  Widget bar(int height, {required Color color}) {
    height = height < 2 ? 2 : height;
    return Container(
      width: 1.75,
      height: height.toDouble(),
      margin: EdgeInsets.symmetric(horizontal: 0.45),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color,
      ),
    );
  }
}
