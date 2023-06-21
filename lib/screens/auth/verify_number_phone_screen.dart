import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/auth/Login/login_bloc.dart';
import 'package:siraf3/bloc/auth/verifyNumber/verify_number_phone_bloc.dart';
import 'package:siraf3/dark_themes.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/screens/auth/login_screen.dart';
import 'package:siraf3/screens/home_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/block_btn.dart';
import 'package:siraf3/widgets/my_image.dart';
import 'package:siraf3/widgets/my_text_button.dart';
import 'package:siraf3/widgets/my_text_icon_button.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:siraf3/main.dart';

class VerifyNumberPhoneScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _VerifyNumberPhoneScreen();

  String numberPhone;
  bool pop;

  VerifyNumberPhoneScreen({required this.pop, required this.numberPhone});
}

class _VerifyNumberPhoneScreen extends State<VerifyNumberPhoneScreen> {
  TextEditingController codeFieldController = TextEditingController();

  VerifyNumberPhoneBloc verifyNumberPhoneBloc = VerifyNumberPhoneBloc();
  LoginBloc loginBloc = LoginBloc();

  late Size size;
  late Timer _timer;
  late int _timeLeft;

  bool codeFieldEnabled = true;

  void _startTimer() {
    setState(() {
      _timeLeft = 120;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }
      setState(() {
        setState(() {
          _timeLeft--;
        });
        if (_timeLeft == 0) {
          setState(() {
            _timer.cancel();
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _startTimer();

    verifyNumberPhoneBloc.stream.listen((state) {
      setState(() => codeFieldEnabled = state is! VerifyNumberPhoneLoading);

      if (state is VerifyNumberPhoneError) {
        notify(state.message);
        return;
      }

      if (state is VerifyNumberPhoneSuccess) {
        _pushToHome();
        return;
      }
    });

    loginBloc.stream.listen((state) {
      if (state is LoginError) {
        notify(state.message);
        return;
      }

      if (state is LoginSuccess) {
        _startTimer();
        return;
      }
    });
  }

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();

    verifyNumberPhoneBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: App.theme.primaryColor,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBody: true,
          backgroundColor: App.theme.dialogBackgroundColor,
          body: Column(
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: CustomPaint(
                      painter: _LogoBackground(),
                      size: Size(MediaQuery.of(context).size.width, 250),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 70),
                        MyImage(
                          image: AssetImage("assets/images/siraf_logo.png"),
                          width: 60,
                          height: 60,
                        ),
                        SizedBox(height: 25),
                        Text(
                          "تایید شماره موبایل",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: "KalamehBlack",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 5, bottom: 2),
                        child: Text(
                          "کد تایید",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            fontFamily: "IRANSansBold",
                          ),
                        ),
                      ),
                      TextField2(
                        controller: codeFieldController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          enabled: codeFieldEnabled,
                          fillColor: App.isDark
                              ? DarkThemes.background
                              : Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          filled: true,
                        ),
                        textInputAction: TextInputAction.send,
                        textDirection: TextDirection.ltr,
                        autocorrect: false,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: App.theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      MyTextIconButton(
                        icon: Icon(Icons.edit_rounded,
                            color: App.theme.primaryColor, size: 15),
                        text: "ویرایش شماره موبایل",
                        onPressed: editNumberPhone,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(top: 15, bottom: 10),
                          child: MyTextButton(
                            border: _timeLeft == 0,
                            onPressed: sendAgain,
                            text: _timeLeft > 0
                                ? "ارسال مجدد کد (${_timeLeft})"
                                : "ارسال مجدد کد",
                            disableTextColor: Colors.black,
                            fontSize: 10,
                            disable: _timeLeft > 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BlocBuilder<VerifyNumberPhoneBloc, VerifyNumberPhoneState>(
                bloc: verifyNumberPhoneBloc,
                builder: (context, state) {
                  return BlockBtn(
                    onTap: login,
                    text: "ورود",
                    isLoading: state is VerifyNumberPhoneLoading,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void login() {
    String code = codeFieldController.value.text;

    if (!code.isNotNullOrEmpty()) {
      return notify("کد تایید را وارد نکرده اید");
    }

    verifyNumberPhoneBloc.add(VerifyNumberPhoneRequestEvent(
        numberPhone: widget.numberPhone, code: code));
  }

  void sendAgain() {
    loginBloc.add(LoginRequestEvent(widget.numberPhone));
  }

  void editNumberPhone() {
    dispose();
    Navigator.pop(context);
  }

  void _pushToHome() {
    if (widget.pop) {
      Navigator.pop(context, 'ok_pop');
    } else {
      pushAndRemoveUntil(context, HomeScreen());
    }
  }
}

class _LogoBackground extends CustomPainter {
  @override
  @override
  void paint(Canvas canvas, Size size) {
    var h = size.height;
    var w = size.width;

    var waveWidth = size.width / 3;

    var paint = Paint()
      ..color = App.theme.primaryColor
      ..strokeWidth = 5;

    Path path = Path();

    path.moveTo(0, 0);
    path.lineTo(0, h);
    path.quadraticBezierTo(waveWidth * 0.2, h + 50, waveWidth * 0.9, h);
    path.quadraticBezierTo(waveWidth * 1.6, h - 50, waveWidth * 2, h);
    path.quadraticBezierTo(waveWidth * 2.25, h + 30, waveWidth * 2.5, h);
    path.quadraticBezierTo(waveWidth * 2.7, h - 20, waveWidth * 3, h);
    path.lineTo(w, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
