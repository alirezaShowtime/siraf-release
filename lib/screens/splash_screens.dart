import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siraf3/bloc/check_version_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/http2.dart' as http2;
import 'package:siraf3/models/group.dart';
import 'package:siraf3/models/user.dart';
import 'package:siraf3/screens/home_screen.dart';
import 'package:siraf3/screens/intro_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/utilities/get_last_version.dart';
import 'package:siraf3/widgets/confirm_dialog.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  final Duration duration = const Duration(milliseconds: 500);
  late AnimationController _controller;
  bool isHidden = true;
  CheckVersionBloc checkVersionBloc = CheckVersionBloc();

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

    checkVersionBloc.stream.listen((state) async {
      if (state is CheckVersionErrorState) handleNextActions();
      if (state is! CheckVersionSuccessState) return;

      if (!state.hasUpdate || !state.isRequired) {
        handleNextActions();
        return;
      }

      animationDialog(
          context: context,
          builder: (dialogContext) {
            return ConfirmDialog(
              dialogContext: dialogContext,
              title: "بروزرسانی",
              content: "نسخه جدیدی از برنامه منتشر شده است.",
              applyText: "بروزرسانی",
              cancelText: "خروج از برنامه",
              onApply: () => GetLastVersion.start(state.downloadUrl),
              onCancel: applicationExit,
            );
          });
    });
  }

  handleNextActions() async {
    if (await User.hasToken()) {
      await refreshToken();
    }

    await getTicketGroups();

    goNextScreen();
  }

  checkConnectionAndGoNextScreen() async {
    setState(() {
      activeConnection = true;
    });
    await Future.delayed(Duration(milliseconds: 2500));
    if (await checkUserConnection()) {
      checkVersionBloc.add(CheckVersionEvent());
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        SizedBox(height: 100, width: 140),
                        AnimatedPositioned(
                          duration: duration,
                          top: isHidden ? 0 : 35,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "پلتفرم دسترسی به املاک شهر",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'KalamehBlack',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 0,
                          left: 0,
                          top: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                color: Themes.primary,
                                child: Image(
                                  image: AssetImage('assets/images/siraf_logo_text.png'),
                                  width: 130,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (activeConnection) SpinKitThreeBounce(size: 15, color: Colors.white, duration: Duration(milliseconds: 800)),
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

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }

  Future refreshToken() async {
    var user = (await User.fromLocal());
    var response = await http2.post(Uri.parse("https://auth.siraf.app/api/token/refresh/"),
        body: jsonEncode({
          "refresh": user.refreshToken ?? "",
        }),
        headers: {
          "Content-Type": "application/json",
        });

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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => IntroScreen()));
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
