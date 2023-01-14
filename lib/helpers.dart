import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as fr;
import 'package:oktoast/oktoast.dart';
import 'package:path/path.dart' as p;
import 'package:siraf3/config.dart';
import 'package:siraf3/themes.dart';
import 'package:url_launcher/url_launcher.dart';

const image_extensions = <String>["png", "jpg", "jpeg"];
const video_extensions = <String>["mp4", "mov", "wmv", "avi", "mkv"];

void notify(String msg, {TextDirection textDirection = TextDirection.rtl, Duration? duration = null}) {
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

String convertUtf8(String content) {
  return Utf8Decoder(allowMalformed: true).convert(content.codeUnits);
}

dynamic jDecode(String json) {
  return jsonDecode(convertUtf8(json));
}

callToSupport() async {
  const url = "tel:" + SUPPORT_PHONE;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    notify('نتوانستیم تلفن را بازکنیم با شماره ' + SUPPORT_PHONE + 'تماس بگیرید');
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

Uri getFileUrl(String endpoint) {
  return Uri.parse("https://file.siraf.app/api/${endpoint}");
}

Uri getEstateUrl(String endpoint) {
  return Uri.parse("https://estate.siraf.app/api/${endpoint}");
}

String getImageUrl(String file) {
  return "https://master.siraf.biz/${file}";
}

bool isResponseOk(http.Response response) {
  if (response.statusCode >= 400) {
    return false;
  }

  var json = jsonDecode(response.body);
  if (json['status'] != 1) {
    return false;
  }

  return true;
}

const API_HOST = 'api.siraf.app';

Uri createAuthUrlByEndPoint(String endPoint, {Map<String, dynamic>? queryParams = null}) {
  return Uri.https(API_HOST, "api/v1/account/${endPoint}", queryParams);
}

String phoneFormat(String numberPhone) {
  var zeroPrefix = numberPhone.startsWith("09");

  if (!zeroPrefix) {
    numberPhone = "0$numberPhone";
  }

  var formatted = "${numberPhone.substring(0, 4)}  ${numberPhone.substring(4, 7)}  ${numberPhone.substring(7, 11)}";

  return zeroPrefix ? formatted : formatted.replaceFirst("09", "9");
}

String icon(String iconName, {String extension = "png"}) {
  return 'assets/images/ic_$iconName.$extension';
}
