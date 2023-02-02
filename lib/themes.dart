import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Themes {
  static const primary = Color(0xff0067A5);
  static const appBar = Color(0xffffffff);
  static const statusBar = Color(0xff0067A5);
  static const blue = Color(0xff0067A5);
  static const background = Color(0xfffafbfd);
  static const background2 = Color(0xffffffff);
  static const secondary = Color(0xff0067A5);
  static const secondary2 = Color(0xff707070);
  static const text = Color(0xff3d3d3d);
  static const textGrey = Color(0xff707070);
  static const textLight = Color(0xffffffff);
  static const icon = Color(0xff3d3d3d);
  static const iconGrey = Color(0xff707070);
  static const iconLight = Color(0xffffffff);

  static const disabled = Color.fromARGB(255, 180, 180, 180);

  static const searchBoxBackground = Color(0xfff0f0f0);
  static const searchBoxHint = Color(0xff969696);
  static const searchBoxBorder = Color(0xffeae7e7);

  static const inputHint = Color(0xff9b9b9b);
  static const inputBorder = Color(0xff0067a5);
  static const inputBorderNormal = Color(0xffeae7e7);

  static const blueSky = Color(0x704abbff);

  static ThemeData themeData() {
    return ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: 'IranSans',
      backgroundColor: Themes.background,
      scaffoldBackgroundColor: Themes.background,
      accentColor: Themes.secondary,
      secondaryHeaderColor: Themes.secondary,
      primaryColor: Themes.primary,
    );
  }
}
