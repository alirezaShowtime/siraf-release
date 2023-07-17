import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/auth/Login/login_bloc.dart';
import 'package:siraf3/dark_themes.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/screens/auth/verify_number_phone_screen.dart';
import 'package:siraf3/screens/webview_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/block_btn.dart';
import 'package:siraf3/widgets/my_image.dart';
import 'package:siraf3/widgets/text_form_field_2.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreen();

  bool pop;

  LoginScreen({this.pop = false});
}

class _LoginScreen extends State<LoginScreen> {
  TextEditingController numberPhoneFieldController = TextEditingController();

  LoginBloc _bloc = LoginBloc();
  bool showPassword = false;
  bool numberPhoneFieldEnabled = true;

  late Size size;

  void _blocListener() {
    _bloc.stream.listen((state) {
      setState(() => numberPhoneFieldEnabled = state is! LoginLoading);

      if (state is LoginError) {
        notify(state.message);
        return;
      }

      if (state is LoginSuccess) {
        _pushToVerifyScreen(state.numberPhone);
        return;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _blocListener();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
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
                          "ورود|ثبت نام",
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
                          "شماره موبایل",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            fontFamily: "IRANSansBold",
                          ),
                        ),
                      ),
                      TextFormField2(
                        controller: numberPhoneFieldController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          counterText: "",
                          enabled: numberPhoneFieldEnabled,
                          fillColor: App.isDark ? DarkThemes.background : Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        filled: true,
                      ),
                      textInputAction: TextInputAction.send,
                      textDirection: TextDirection.ltr,
                      autocorrect: false,
                      maxLength: 11,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "IranSansBold",
                        color: App.theme.textTheme.bodyLarge?.color,
                      ),
                      validator: (String? phone) {
                        if (phone == null || phone.isEmpty) {
                          return 'شماره موبایل را وارد کنید';
                        }
                        if (phone.length != 11) {
                          return 'شماره موبایل باید 11 رقم باشد';
                        }
                        if (!phone.startsWith("09")) {
                          return 'شماره موبایل باید با 09 شروع شود';
                        }
                      },
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(7),
                onTap: () {
                  push(context, WebViewScreen(title: 'قوانین مقررات', url: 'https://article.siraf.biz/api/v1/rules'));
                },
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    "شرایط استفاده از خدمات، قوانین و حریم خصوصی",
                    style: TextStyle(
                      color: App.theme.primaryColor,
                      fontFamily: "IRANSansBold",
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
              BlocBuilder<LoginBloc, LoginState>(
                bloc: _bloc,
                builder: (context, state) {
                  return BlockBtn(
                    onTap: _login,
                    text: "ارسال کد",
                    isLoading: state is LoginLoading,
                  );
                },
              ),
            ],
          ),
        ),
      );
  }

  void _login() {
    String numberPhone = numberPhoneFieldController.value.text;

    if (!numberPhone.isNotNullOrEmpty()) {
      return notify("شماره وارد نشده است.");
    }

    _bloc.add(LoginRequestEvent(numberPhone));
  }

  void _pushToVerifyScreen(String numberPhone) async {
    var result = await push(context, VerifyNumberPhoneScreen(pop: widget.pop, numberPhone: numberPhone));
    if (widget.pop && result == 'ok_pop') {
      Navigator.pop(context, result);
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
      ..color = Themes.primary
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
