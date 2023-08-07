import 'package:flutter/material.dart';
import 'package:siraf3/themes.dart';

PopupMenuItem<T> MyPopupMenuItem<T>({
  required label,
  IconData? icon,
  Widget? iconWidget,
  bool enable = true,
  void Function()? onTap = null,
  dynamic value = null,
  bool withSpace = false,
  TextDirection direction = TextDirection.rtl,
}) {
  return PopupMenuItem<T>(
    enabled: enable,
    onTap: onTap,
    value: value,
    child: Directionality(
      textDirection: direction,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        child: Row(
          textDirection: withSpace ? TextDirection.ltr : null,
          mainAxisAlignment: withSpace ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
          children: [
            if (icon != null || iconWidget != null || withSpace) iconWidget != null ? iconWidget : Icon(icon, size: 24),
            if (iconWidget != null || icon != null) SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: enable ? Themes.themeData().textTheme.bodyLarge?.color : Colors.grey,
                fontSize: 11,
                fontFamily: "IranSansMedium",
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
