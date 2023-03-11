import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/user.dart';
import 'package:siraf3/screens/home_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/http2.dart' as http2;

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
    await Future.delayed(Duration(milliseconds: 500));
    if (await checkUserConnection()) {
      if (await User.hasToken()) {
        refreshToken();
      } else {
        goNextScreen();
      }
    }
  }

  bool activeConnection = true;
  Future<bool> checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
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

  void refreshToken() async {
    var user = (await User.fromLocal());
    var response = await http2.post(Uri.parse("https://auth.siraf.app/api/token/refresh/"), body: jsonEncode({
      "refresh" : user.refreshToken ?? "",
    }));
    
    if (isResponseOk(response)) {
      var body = jDecode(response.body);
      if (body["access"] is String) {
        user.refreshToken = body["access"];
        await user.save();
      }
    }

    goNextScreen();
  }

  void goNextScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(),
      ),
    );
  }
}