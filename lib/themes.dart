import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  static SystemUiOverlayStyle getSystemUiOverlayStyle() => SystemUiOverlayStyle(
        statusBarColor: Themes.appBar,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Themes.appBar,
        systemNavigationBarDividerColor: Color(0xffEEEEEE),
        systemNavigationBarIconBrightness: Brightness.dark,
      );

  static SystemUiOverlayStyle getSystemUiOverlayStyleTransparent() => SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Themes.appBar,
        systemNavigationBarDividerColor: Color(0xffEEEEEE),
        systemNavigationBarIconBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: false,
      );

  static ThemeData themeData() {
    return ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: 'IranSans',
      backgroundColor: Themes.background,
      scaffoldBackgroundColor: Themes.background,
      dialogBackgroundColor: Themes.background2,
      accentColor: Themes.secondary,
      secondaryHeaderColor: Themes.secondary,
      primaryColor: Themes.primary,
      appBarTheme: AppBarTheme(
        shadowColor: Color(0x50000000),
        backgroundColor: Themes.appBar,
        foregroundColor: Themes.text,
        titleTextStyle: TextStyle(
            fontSize: 16, color: Themes.text, fontFamily: "IranSansMedium"),
        iconTheme: IconThemeData(
          color: Themes.icon,
        ),
        titleSpacing: 0,
        elevation: 0.7,
        actionsIconTheme: IconThemeData(
          color: Themes.icon,
        ),
      ),
      iconTheme: IconThemeData(
        color: Themes.icon,
      ),
      tooltipTheme: TooltipThemeData(
          textStyle: TextStyle(
        color: Themes.textGrey,
      )),
      shadowColor: Colors.grey.withOpacity(0.1),
      textTheme: TextTheme(
        bodyText1: TextStyle(),
        bodyText2: TextStyle(),
      ).apply(
        bodyColor: Themes.text,
        displayColor: Themes.textGrey,
      ),
    );
  }
}
