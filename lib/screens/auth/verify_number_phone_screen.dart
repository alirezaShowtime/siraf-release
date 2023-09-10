import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:siraf3/bloc/auth/Login/login_bloc.dart';
import 'package:siraf3/bloc/auth/verifyNumber/verify_number_phone_bloc.dart';
import 'package:siraf3/dark_themes.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/screens/home_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/block_btn.dart';
import 'package:siraf3/widgets/my_image.dart';
import 'package:siraf3/widgets/my_text_button.dart';
import 'package:siraf3/widgets/my_text_icon_button.dart';
import 'package:siraf3/widgets/text_field_2.dart';
import 'package:siraf3/widgets/text_form_field_2.dart';

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

    codeFocusNode.addListener(() {
      setState(() {
        hasFocus = codeFocusNode.hasFocus;
      });
    });

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

  FocusNode codeFocusNode = FocusNode();

  bool hasFocus = false;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: App.getSystemUiOverlayTransparentLight(),
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
                    painter: _LogoBackgroundOval(),
                    size: Size(MediaQuery.of(context).size.width, 250),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(bottom: 10),
                      child: Image(
                        image: AssetImage("assets/images/login_background.png"),
                        fit: BoxFit.cover,
                        height: 180,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Image(
                      image: AssetImage(
                        "assets/images/login_logo_siraf.png",
                      ),
                      width: 80,
                    ),
                  ),
                ),
              ],
            ),
            Transform.translate(
              offset: Offset(0, -25),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                width: MediaQuery.of(context).size.width,
                height: 270,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 3,
                      color: (App.theme.shadowColor).withOpacity(0.15),
                      spreadRadius: 1,
                      offset: Offset(0, 1),
                    ),
                    BoxShadow(
                      blurRadius: 3,
                      color: (App.theme.shadowColor).withOpacity(0.15),
                      spreadRadius: 1,
                      offset: Offset(1, 0),
                    ),
                    BoxShadow(
                      blurRadius: 3,
                      color: (App.theme.shadowColor).withOpacity(0.15),
                      spreadRadius: 1,
                      offset: Offset(-1, 0),
                    ),
                  ],
                  color: App.theme.dialogBackgroundColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "تایید شماره همراه",
                      style: TextStyle(
                        color: App.theme.textTheme.bodyLarge?.color,
                        fontFamily: "IranSansBold",
                        fontSize: 19,
                      ),
                    ),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "کد تایید",
                            style: TextStyle(
                              fontSize: 11,
                              color: hasFocus ? App.theme.primaryColor : App.theme.textTheme.bodyLarge?.color,
                              fontFamily: "IranSansMedium",
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextField2(
                            controller: codeFieldController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              counterText: "",
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: App.theme.tooltipTheme.textStyle?.color ?? Themes.textGrey),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: App.theme.tooltipTheme.textStyle?.color ?? Themes.textGrey),
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: App.theme.tooltipTheme.textStyle?.color ?? Themes.textGrey),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              hintTextDirection: TextDirection.ltr,
                            ),
                            textInputAction: TextInputAction.send,
                            textDirection: TextDirection.ltr,
                            autocorrect: false,
                            maxLines: 1,
                            maxLength: 6,
                            textAlign: TextAlign.center,
                            focusNode: codeFocusNode,
                            onSubmitted: (_) {
                              login();
                            },
                            style: TextStyle(
                              fontSize: 18.5,
                              fontFamily: "IranSansMedium",
                              color: App.theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                        SizedBox(height: 3),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyTextIconButton(
                              icon: Icon(Icons.edit_rounded, color: App.theme.primaryColor, size: 15),
                              text: "ویرایش شماره موبایل",
                              onPressed: editNumberPhone,
                            ),
                            TextButton(
                              onPressed: sendAgain,
                              style: TextButton.styleFrom(
                                foregroundColor: App.theme.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                _timeLeft > 0 ? "ارسال مجدد کد (${_timeLeft})" : "ارسال مجدد کد",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: "IranSansBold",
                                  color: _timeLeft > 0 ? App.theme.textTheme.bodyLarge?.color : App.theme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    BlocBuilder<VerifyNumberPhoneBloc, VerifyNumberPhoneState>(
                      bloc: verifyNumberPhoneBloc,
                      builder: (context, state) {
                        return BlockBtn(
                          onTap: login,
                          text: "ورود",
                          height: 40,
                          radius: 5,
                          isLoading: state is VerifyNumberPhoneLoading,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void login() {
    String code = codeFieldController.value.text;

    if (!code.isNotNullOrEmpty()) {
      return notify("کد تایید را وارد نکرده اید");
    }

    verifyNumberPhoneBloc.add(VerifyNumberPhoneRequestEvent(numberPhone: widget.numberPhone, code: code));
  }

  void sendAgain() {
    if (_timeLeft > 0) return;
    
    loginBloc.add(LoginRequestEvent(widget.numberPhone));
  }

  void editNumberPhone() {
    dispose();
    Navigator.pop(context);
  }

  void _pushToHome() {
    SystemChrome.setSystemUIOverlayStyle(App.isDark ? DarkThemes.getSystemUiOverlayStyle() : Themes.getSystemUiOverlayStyle());

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

class _LogoBackgroundOval extends CustomPainter {
  @override
  @override
  void paint(Canvas canvas, Size size) {
    var h = size.height;
    var w = size.width;

    var width = size.width;

    var paint = Paint()
      ..color = App.theme.primaryColor
      ..strokeWidth = 5;

    Path path = Path();

    path.moveTo(0, 0);
    path.lineTo(0, h);
    path.quadraticBezierTo(width * 0.5, h + 70, width, h);
    path.lineTo(w, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
