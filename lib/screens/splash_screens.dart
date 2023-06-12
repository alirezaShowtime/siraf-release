import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/main.dart';
import 'package:siraf3/models/group.dart';
import 'package:siraf3/models/user.dart';
import 'package:siraf3/screens/home_screen.dart';
import 'package:siraf3/screens/intro_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final Duration duration = const Duration(milliseconds: 500);
  late AnimationController _controller;
  bool isHidden = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

    _controller = AnimationController(vsync: this, duration: duration);

    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _controller.forward();
        isHidden = !isHidden;
      });
    });

    checkConnectionAndGoNextScreen();
  }

  checkConnectionAndGoNextScreen() async {
    setState(() {
      activeConnection = true;
    });
    await Future.delayed(Duration(milliseconds: 2500));
    if (await checkUserConnection()) {
      if (await User.hasToken()) {
        await refreshToken();
      }

      await getTicketGroups();

      goNextScreen();
    }
  }

  bool activeConnection = true;

  Future<bool> checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('file.siraf.app');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          activeConnection = true;
        });
        return true;
      }
    } on SocketException catch (_) {
      setState(() {
        activeConnection = false;
      });
      return false;
    }
    setState(() {
      activeConnection = false;
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Themes.primary,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: Themes.primary,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/images/siraf_logo.png'),
                      width: 120,
                      height: 120,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Image(
                      image: AssetImage('assets/images/logo_shadow.png'),
                      width: 100,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: activeConnection ? 140 : 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        SizedBox(height: 100, width: 120),
                        AnimatedPositioned(
                          duration: duration,
                          top: isHidden ? 0 : 35,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 2.0),
                            child: Text(
                              "پایان جستجو اینجاست!",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'KalamehBlack',
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Themes.primary,
                          child: Image(
                            image:
                                AssetImage('assets/images/siraf_logo_text.png'),
                            width: 120,
                          ),
                        ),
                      ],
                    ),
                    if (activeConnection)
                      SpinKitThreeBounce(
                          size: 15,
                          color: Colors.white,
                          duration: Duration(milliseconds: 800)),
                    if (!activeConnection)
                      Text(
                        "خطا در اتصال به اینترنت!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    if (!activeConnection) SizedBox(height: 10),
                    if (!activeConnection)
                      GestureDetector(
                        onTap: checkConnectionAndGoNextScreen,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "تلاش مجدد",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.refresh, color: Colors.white),
                          ],
                        ),
                      ),
                    SizedBox(height: 20)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  Future refreshToken() async {
    var user = (await User.fromLocal());
    var response =
        await http2.post(Uri.parse("https://auth.siraf.app/api/token/refresh/"),
            body: jsonEncode({
              "refresh": user.refreshToken ?? "",
            }));

    if (isResponseOk(response)) {
      var body = jDecode(response.body);
      if (body["access"] is String) {
        user.refreshToken = body["access"];
        await user.save();
      }
    }
  }

  void goNextScreen() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    if (!((await sharedPreferences.getBool("IS_INTRO_SHOW")) ?? false)) {
      sharedPreferences.setBool("IS_INTRO_SHOW", true);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => IntroScreen()));
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(),
      ),
    );
  }

  Future getTicketGroups() async {
    var response = await http2.get(getTicketUrl("group/groups/"));

    if (isResponseOk(response)) {
      var json = jDecode(response.body);
      GroupModel.saveList(GroupModel.fromList(json['data']));
    }
  }
}
