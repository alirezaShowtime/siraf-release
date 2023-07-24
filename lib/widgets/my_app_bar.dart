import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siraf3/themes.dart';

class MyAppBar extends AppBar {
  MyAppBar({
    super.key,
    super.leading,
    super.automaticallyImplyLeading = true,
    super.title,
    super.actions,
    super.flexibleSpace,
    super.bottom,
    super.elevation,
    super.scrolledUnderElevation,
    super.notificationPredicate = defaultScrollNotificationPredicate,
    super.shadowColor,
    super.surfaceTintColor,
    super.shape,
    super.backgroundColor,
    super.foregroundColor,
    super.brightness,
    super.iconTheme,
    super.actionsIconTheme,
    super.textTheme,
    super.primary = true,
    super.centerTitle,
    super.excludeHeaderSemantics = false,
    super.titleSpacing,
    super.toolbarOpacity = 1.0,
    super.bottomOpacity = 1.0,
    super.toolbarHeight,
    super.leadingWidth,
    super.backwardsCompatibility,
    super.toolbarTextStyle,
    super.titleTextStyle,
    super.systemOverlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Themes.appBar,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Themes.appBar,
      systemNavigationBarDividerColor: Themes.appBar,
    ),
  });
}
