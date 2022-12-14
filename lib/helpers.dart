import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path/path.dart' as p;
import 'package:intl/intl.dart' as fr;
import 'package:siraf3/config.dart';
import 'package:siraf3/themes.dart';
import 'package:url_launcher/url_launcher.dart';

const image_extensions = <String>["png", "jpg", "jpeg"];
const video_extensions = <String>["mp4", "mov", "wmv", "avi", "mkv"];

void notify(String msg,
    {TextDirection textDirection = TextDirection.rtl,
    Duration? duration = null}) {
  showToast(
    msg,
    textDirection: textDirection,
    duration: duration,
    textPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    textStyle: TextStyle(
      fontFamily: 'BYekan',
      color: Themes.textLight,
      fontSize: 15.5,
    ),
  );
}

bool checkImageExtension(String path) {
  for (String ext in image_extensions) {
    if (p.extension(path).replaceAll('.', '').toLowerCase() == ext) {
      return true;
    }
  }

  return false;
}

bool checkVideoExtension(String path) {
  for (String ext in video_extensions) {
    if (p.extension(path).replaceAll('.', '').toLowerCase() == ext) {
      return true;
    }
  }

  return false;
}

String number_format(number) {
  return fr.NumberFormat.decimalPattern().format(number);
}

String price_text(price) {
  if (price == null || price == 0 || price == 1) {
    return "توافقی";
  }
  return number_format(price) + ' تومان';
}

Map flipMap(Map map) {
  Map newMap = {};
  map.forEach((key, value) {
    newMap[value] = key;
  });
  return newMap;
}

String convertUtf8(List<int> content) {
  return Utf8Decoder(allowMalformed: true).convert(content);
}

callToSupport() async {
  const url = "tel:" + SUPPORT_PHONE;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    notify(
        'نتوانستیم تلفن را بازکنیم با شماره ' + SUPPORT_PHONE + 'تماس بگیرید');
  }
}

callTo(String number) async {
  var url = "tel:" + number;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    notify('نتوانستیم تلفن را بازکنیم با شماره ' + number + 'تماس بگیرید');
  }
}

bool isNumeric(String? s) {
  if (s == null) {
    return false;
  }
  return double.parse(s, (e) => -1) != -1;
}
