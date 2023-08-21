import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:screenshot/screenshot.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/avatar.dart';
import 'package:siraf3/widgets/simple_app_bar.dart';

class EstateShareScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EstateShareScreen();

  String shareLink;
  String estateName;
  String? estateLogo;
  String managerName;

  EstateShareScreen({
    required this.shareLink,
    required this.estateName,
    this.estateLogo,
    required this.managerName,
  });
}

class _EstateShareScreen extends State<EstateShareScreen> {
  ScreenshotController screenshotController = ScreenshotController();

  Uint8List? qrImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(
        titleText: "اشتراک گذاری",
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Screenshot(
            controller: screenshotController,
            child: Container(
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 50),
                      Avatar(
                        image: NetworkImage(widget.estateLogo ?? ""),
                        loadingImage: AssetImage("assets/images/profile.jpg"),
                        errorImage: AssetImage("assets/images/profile.jpg"),
                        size: 80,
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.estateName,
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: "IranSansBold",
                          color: Themes.primary,
                        ),
                      ),
                      Text(
                        "با مدیریت ${widget.managerName}",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontFamily: "IranSansBold",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  PrettyQr(
                    image: AssetImage("assets/images/siraf_icon.png"),
                    data: widget.shareLink,
                    size: 200,
                    roundEdges: true,
                    elementColor: Colors.black,
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: SizedBox(
                width: 230,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        FlutterShare.share(
                          title: 'اشتراک گذاری',
                          text: 'لینک پروفایل املاک ${widget.estateName} \n با مدیریت : ${widget.managerName}',
                          linkUrl: widget.shareLink,
                          chooserTitle: 'اشتراک گذاری در',
                        );
                      },
                      icon: Icon(Icons.share_rounded, size: 32, color: Colors.black),
                    ),
                    IconButton(
                      onPressed: screenshot,
                      icon: Icon(
                        Icons.file_download_rounded,
                        size: 32,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void screenshot() async {
    if (qrImage != null) {
      final f = DateFormat("yyyy_MM_dd");
      var name = 'siraf_share_qrcode_${f.format(DateTime.now())}.png';
      String downloadPath = (await getDownloadPath())!;
      var path = downloadPath + "/Siraf/Share/$name";
      var qrImageFile = File(path);

      if (await qrImageFile.exists()) {
        path = generateUniquePath(path);
      }

      await qrImageFile.create(recursive: true);
      await (await (await qrImageFile.open(mode: FileMode.write)).writeFrom(qrImage!)).close();
      notify("در مسیر ${path.replaceFirst(downloadPath, "Downloads")} ذخیره شد.");
      return;
    }

    screenshotController.capture().then((Uint8List? image) {
      if (image == null) return;
      qrImage = image;
      screenshot();
    });
  }
}