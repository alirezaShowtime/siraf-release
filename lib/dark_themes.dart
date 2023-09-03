import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DarkThemes {
  static const primary = Color(0xff0067A5);
  static const appBar = Color(0xff121418);
  static const statusBar = Color(0xff0067A5);
  static const blue = Color(0xff0067A5);
  static const background = Color(0xff1b1f24);
  static const background2 = Color(0xff121418);
  static const secondary = Color(0xff0067A5);
  static const secondary2 = Color(0xff707070);
  static const text = Color(0xff3d3d3d);
  static const textGrey = Color(0xff707070);
  static const textLight = Color(0xffffffff);
  static const textMediumLight = Color(0xffc4c4c4);
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
        statusBarColor: DarkThemes.appBar,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: DarkThemes.appBar,
        systemNavigationBarDividerColor: Color(0x00EEEEEE),
        systemNavigationBarIconBrightness: Brightness.dark,
      );

  static SystemUiOverlayStyle getSystemUiOverlayStyleTransparent({Brightness? statusBarIconBrightness}) => SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: statusBarIconBrightness ?? Brightness.dark,
        systemNavigationBarColor: DarkThemes.appBar,
        systemNavigationBarDividerColor: Color(0x00EEEEEE),
        systemNavigationBarIconBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: false,
      );

  static ThemeData darkThemeData() {
    return ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: 'IranSans',
      backgroundColor: DarkThemes.background,
      scaffoldBackgroundColor: DarkThemes.background,
      dialogBackgroundColor: DarkThemes.background2,
      accentColor: DarkThemes.secondary,
      secondaryHeaderColor: DarkThemes.secondary,
      primaryColor: DarkThemes.primary,
      appBarTheme: AppBarTheme(
        shadowColor: Color(0x50ffffff),
        backgroundColor: DarkThemes.appBar,
        foregroundColor: DarkThemes.textLight,
        titleTextStyle: TextStyle(
            fontSize: 16,
            color: DarkThemes.textLight,
            fontFamily: "IranSansMedium"),
        titleSpacing: 0,
        elevation: 0.7,
        actionsIconTheme: IconThemeData(
          color: DarkThemes.iconLight,
        ),
      ),
      iconTheme: IconThemeData(
        color: DarkThemes.iconLight,
      ),
      tooltipTheme: TooltipThemeData(
          textStyle: TextStyle(
        color: DarkThemes.textMediumLight,
      )),
      shadowColor: Colors.transparent,
      textTheme: TextTheme(
        bodyText1: TextStyle(),
        bodyText2: TextStyle(),
      ).apply(
        bodyColor: DarkThemes.textLight,
        displayColor: DarkThemes.textLight,
      ),
    );
  }
}
