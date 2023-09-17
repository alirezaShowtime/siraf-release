import 'dart:convert';
import 'dart:io';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as fr;
import 'package:oktoast/oktoast.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/user.dart';
import 'package:siraf3/screens/auth/login_screen.dart';
import 'package:url_launcher/url_launcher.dart';

const image_extensions = <String>["png", "jpg", "jpeg"];
const video_extensions = <String>["mp4", "avi"];

copy(String text) async {
  await Clipboard.setData(ClipboardData(text: text));
}

void notify(String? msg, {TextDirection textDirection = TextDirection.rtl, Duration? duration = null}) {
  if (msg == null) return;
  showToast(
    msg,
    textDirection: textDirection,
    duration: duration,
    radius: 10,
    dismissOtherToast: true,
    margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
    constraints: BoxConstraints(minWidth: double.infinity),
    backgroundColor: Color(0xff333333),
    textPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    position: ToastPosition(align: Alignment.bottomCenter),
    textAlign: TextAlign.right,
    textMaxLines: 2,
    textOverflow: TextOverflow.ellipsis,
    textStyle: TextStyle(
      fontFamily: 'IranSansMedium',
      color: Colors.white,
      fontSize: 12,
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

bool checkVirtualTourExtension(String path) {
  if (p.extension(path).replaceAll('.', '').toLowerCase() == "zip") {
    return true;
  }

  return false;
}

String number_format(number, {String? defaultValue}) {
  if (number == null) {
    return defaultValue ?? "";
  }
  if (number is String) {
    number = num.parse(number);
  }
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

String encodeUtf8(String content) {
  return String.fromCharCodes(Utf8Encoder().convert(content));
}

dynamic jDecode(String json) {
  return jsonDecode(convertUtf8(json));
}

callToSupport() async {
  const url = "tel:" + SUPPORT_MOBILE;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    notify('نتوانستیم تلفن را بازکنیم با شماره ' + SUPPORT_MOBILE + 'تماس بگیرید');
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

Uri getTicketUrl(String endpoint) {
  return Uri.parse("https://ticket.siraf.app/api/${endpoint}");
}

Uri getContentUrl(String endpoint) {
  return Uri.parse("https://content.siraf.app/api/${endpoint}");
}

String getImageUrl(String file) {
  return "https://auth.siraf.app${file}";
}

bool isResponseOk(http.Response response) {
  if (response.statusCode == 401) {
    User.remove();
    return false;
  }

  if (response.statusCode >= 400) {
    return false;
  }

  var json = jsonDecode(response.body);
  if (json['status'] != 1) {
    return false;
  }

  return true;
}

bool is401(http.Response response) {
  if (response.statusCode == 401) {
    return true;
  }

  var json = jsonDecode(response.body);
  if (json['code'] == 401 || json['code'] == "401") {
    return true;
  }

  return false;
}

const API_HOST = 'auth.siraf.app';

Uri createAuthUrlByEndPoint(String endPoint, {Map<String, dynamic>? queryParams = null}) {
  return Uri.https(API_HOST, "api/user/${endPoint}", queryParams);
}

String phoneFormat(String numberPhone) {
  var zeroPrefix = numberPhone.startsWith("09");

  if (!zeroPrefix) {
    numberPhone = "0$numberPhone";
  }

  var formatted = "${numberPhone.substring(0, 4)}  ${numberPhone.substring(4, 7)}  ${numberPhone.substring(7, 11)}";

  return zeroPrefix ? formatted : formatted.replaceFirst("09", "9");
}

doWithLogin(BuildContext context, void Function() onLoggedIn, {bool pop = true}) async {
  if (!await User.hasToken()) {
    await push(context, LoginScreen(pop: pop));
    return;
  }
  onLoggedIn();
}

void back<T extends Object?>(BuildContext context, [T? result]) {
  try {
    if (Navigator.canPop(context)) {
      Navigator.pop(context, T);
    }
  } catch (e) {}
}

FaIcon icon(IconData icon, {Color? color, double size = 24}) {
  if (color == null) color = App.theme.iconTheme.color;

  return FaIcon(icon, color: color, size: size);
}

void navigateTo(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
}

bool isValidNumberPhone(String numberPhone) {
  return numberPhone.length == 11;
}

String nonIfZero(number) {
  if (number == 0 || number == .0 || number == "0") return "ندارد";

  return number.toString();
}

String getUrlDelimiter(String url) {
  return !url.contains("?") ? "?" : "&";
}

extension List2<E> on List<E>? {
  List<List<E>> chunk(int chunkSize) {
    var chunks = <List<E>>[];
    if (this.isNotNullOrEmpty()) {
      for (var i = 0; i < this!.length; i += chunkSize) {
        chunks.add(this!.sublist(i, i + chunkSize > this!.length ? this!.length : i + chunkSize));
      }
    }
    return chunks;
  }

  bool isNotNullOrEmpty() {
    return this != null && this!.isNotEmpty;
  }
}

Divider divider({double height = 1}) => Divider(color: App.isDark ? App.theme.shadowColor : Colors.grey.shade300, height: height);

bool resetCreateFileForm = false;
bool resetEditFileForm = false;

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = Set();
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}

extension String2 on String? {
  bool isNotNullOrEmpty() {
    return this != null && this!.isNotEmpty;
  }
}

Future<Directory> getOrCreatePath(dynamic directory) async {
  if (directory is String) {
    directory = Directory(directory);
  }

  var split = (directory as Directory).path.split("/");

  Directory? newDir;

  for (var i = 0; i < split.length - 2; i++) {
    var l = split.getRange(1, i + 3).toList();
    newDir = Directory(l.join("/"));

    if (!await newDir.exists()) {
      newDir.create();
    }
  }
  return newDir!;
}

Future<String?> getDownloadPath({String path = ""}) async {
  Directory? directory;
  try {
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory('/storage/emulated/0/Download');
      // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
      // ignore: avoid_slow_async_io
      if (!await directory.exists()) directory = await getExternalStorageDirectory();
    }
  } catch (err) {
    print("Cannot get download folder path");
  }
  return directory!.path + path;
}

Future<Directory> ticketDownloadPath() async {
  return await getOrCreatePath("${await getDownloadPath()}/Siraf/Ticket");
}

Future<Directory> chatDownloadPath() async {
  return await getOrCreatePath("${await getDownloadPath()}/Siraf/Chat");
}

generateMd5(String data) {
  var content = new Utf8Encoder().convert(data);
  var md5 = crypto.md5;
  var digest = md5.convert(content);
  return hex.encode(digest.bytes);
}

Future<T?> push<T>(BuildContext context, StatefulWidget widget) {
  return Navigator.push<T>(context, MaterialPageRoute(builder: (_) => widget));
}

void pushAndRemoveUntil(BuildContext context, Widget screen) {
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => screen), (route) => false);
}

void pushReplacement(BuildContext context, Widget screen) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => screen));
}

void exitApplication() {
  if (Platform.isAndroid) {
    SystemNavigator.pop();
  } else {
    exit(0);
  }
}

animationDialog({required BuildContext context, required Widget Function(BuildContext) builder}) {
  showGeneralDialog(
    context: context,
    transitionBuilder: (ctx, a1, _, __) {
      var curve = Curves.easeInOut.transform(a1.value);
      return Transform.scale(scale: curve, child: builder.call(ctx));
    },
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) => Container(),
  );
}

String generateUniquePath(String path) {
  var regExp = RegExp(r"_\((\d+)\)\.(\w+)$");
  var extension = RegExp(r"\w+$").firstMatch(path)!.group(0)!;

  if (regExp.hasMatch(path)) {
    var found = regExp.allMatches(path).toList()[0].group(0)!;
    var extension = regExp.allMatches(path).toList()[0].group(2)!;
    var repeat = int.parse(regExp.allMatches(path).toList()[0].group(1)!) + 1;

    return path.replaceAll(found, "_($repeat).$extension");
  }
  return path.replaceAll(".$extension", "_(1).$extension");
}

String timeFormatter(int seconds, {bool hasHour = false}) {
  if (hasHour) {
    var hours = (seconds ~/ 3600).toString();
    var minutes = ((seconds % 3600) ~/ 60).toString();
    var second = ((seconds % 3600) % 60).toString();

    hours = hours.length > 1 ? "$hours" : "0$hours";
    minutes = minutes.length > 1 ? "$minutes" : "0$minutes";
    second = second.length > 1 ? "$second" : "0$second";

    return "${hours}:${minutes}:${second}";
  } else {
    var minutes = (seconds ~/ 60).toString();
    var second = ((seconds % 3600) % 60).toString();

    minutes = minutes.length > 1 ? "$minutes" : "0$minutes";
    second = second.length > 1 ? "$second" : "0$second";

    return "${minutes}:${second}";
  }
}

String dateFormatter(String dateStr) {
  var list = dateStr.split("/");
  var month = int.parse(list[1]);
  var day = int.parse(list[2]);

  var monthNames = {
    1: "فروردین",
    2: "اردیبهشت",
    3: "خرداد",
    4: "تیر",
    5: "مرداد",
    6: "شهریور",
    7: "مهر",
    8: "آبان",
    9: "آذر",
    10: "دی",
    11: "بهمن",
    12: "اسفند",
  };

  return "$day ${monthNames[month]}";
}

void applicationExit() {
  if (Platform.isAndroid) {
    SystemNavigator.pop();
    return;
  }

  if (Platform.isIOS) {
    exit(0);
  }
}

String noneOr(value) {
  if (value == null || value == 0 || value == .0 || value == "0") return "ندارد";

  return value.toString();
}
