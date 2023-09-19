import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class GetLastVersion {
  static String bazar_package_name = "com.farsitel.bazaar";

  static Future<void> start(String downloadUrl) async {
    String packageName = (await PackageInfo.fromPlatform()).packageName;

    if (Platform.isAndroid) {
      var uri = Uri.parse("bazar://details?id=${packageName}");

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        await launchUrl(Uri.parse(downloadUrl), mode: LaunchMode.externalApplication);
      }
    }

    if (Platform.isIOS) {
      //todo
    }
  }

  static Future<void> openBrowser(String downloadUrl) async {
    await launchUrl(Uri.parse(downloadUrl));
  }
}
