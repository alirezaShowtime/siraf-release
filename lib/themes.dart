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

  static final textSelectionTheme = TextSelectionThemeData(
    cursorColor: Themes.primary,
    selectionColor: Themes.primary.withOpacity(0.2),
    selectionHandleColor: Themes.primary,
  );

  static SystemUiOverlayStyle getSystemUiOverlayStyle() => SystemUiOverlayStyle(
        statusBarColor: Themes.appBar,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Themes.appBar,
        systemNavigationBarDividerColor: Color(0xffEEEEEE),
        systemNavigationBarIconBrightness: Brightness.dark,
      );

  static SystemUiOverlayStyle getSystemUiOverlayStyleTransparent({Brightness? statusBarIconBrightness}) => SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: statusBarIconBrightness ?? Brightness.dark,
        systemNavigationBarColor: Themes.appBar,
        systemNavigationBarDividerColor: Color(0xffEEEEEE),
        systemNavigationBarIconBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: false,
      );

  static final primarySwatch = MaterialColor(
    0xff0067A5,
    {
      50: Color(0xff0067A5),
      100: Color(0xff0067A5),
      200: Color(0xff0067A5),
      300: Color(0xff0067A5),
      400: Color(0xff0067A5),
      500: Color(0xff0067A5),
      600: Color(0xff0067A5),
      700: Color(0xff0067A5),
      900: Color(0xff0067A5),
    },
  );

  static ThemeData themeData() {
    return ThemeData(
      primarySwatch: primarySwatch,
      fontFamily: 'IranSans',
      primaryColor: Themes.primary,
      accentColor: Themes.secondary,
      backgroundColor: Themes.background,
      secondaryHeaderColor: Themes.secondary,
      dialogBackgroundColor: Themes.background2,
      scaffoldBackgroundColor: Themes.background,
      shadowColor: Colors.grey.withOpacity(0.1),
      iconTheme: IconThemeData(color: Themes.icon),
      textSelectionTheme: textSelectionTheme,
      tooltipTheme: TooltipThemeData(textStyle: TextStyle(color: Themes.textGrey)),
      appBarTheme: AppBarTheme(
        elevation: 0.7,
        titleSpacing: 0,
        shadowColor: Color(0x50000000),
        foregroundColor: Themes.text,
        backgroundColor: Themes.appBar,
        titleTextStyle: TextStyle(fontSize: 16, color: Themes.text, fontFamily: "IranSansMedium"),
        iconTheme: IconThemeData(color: Themes.icon),
        actionsIconTheme: IconThemeData(color: Themes.icon),
      ),
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
