import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:siraf3/bloc/auth/Login/login_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/screens/auth/verify_number_phone_screen.dart';
import 'package:siraf3/screens/rules_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/block_btn.dart';
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

  bool _checkRules = false;

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

  bool hasFocus = false;

  @override
  void initState() {
    super.initState();
    _blocListener();

    numberPhoneFocusNode.addListener(() {
      setState(() {
        hasFocus = numberPhoneFocusNode.hasFocus;
      });
    });
  }

  FocusNode numberPhoneFocusNode = FocusNode();

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
                      "ورود | ثبت نام",
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
                            "شماره موبایل",
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
                          child: TextFormField2(
                            controller: numberPhoneFieldController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              counterText: "",
                              enabled: numberPhoneFieldEnabled,
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: App.theme.tooltipTheme.textStyle?.color ?? Themes.textGrey),
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: App.theme.tooltipTheme.textStyle?.color ?? Themes.textGrey),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: App.theme.tooltipTheme.textStyle?.color ?? Themes.textGrey),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              hintText: "0  9  _  _  _  _  _  _  _  _  _",
                              hintTextDirection: TextDirection.ltr,
                              hintStyle: TextStyle(
                                fontSize: 18.5,
                                fontFamily: "IranSansMedium",
                                color: App.theme.tooltipTheme.textStyle?.color ?? Themes.textGrey,
                              ),
                            ),
                            textInputAction: TextInputAction.send,
                            textDirection: TextDirection.ltr,
                            autocorrect: false,
                            maxLines: 1,
                            inputFormatters: [
                              MaskTextInputFormatter(
                                mask: '#  #  #  #  #  #  #  #  #  #  #',
                                filter: {"#": RegExp(r'[0-9]')},
                              ),
                            ],
                            textAlign: TextAlign.center,
                            focusNode: numberPhoneFocusNode,
                            onFieldSubmitted: (_) {
                              _login();
                            },
                            style: TextStyle(
                              fontSize: 18.5,
                              fontFamily: "IranSansMedium",
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
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: Checkbox(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                        side: BorderSide(color: (App.theme.textTheme.bodyLarge?.color ?? Themes.text).withOpacity(0.7), width: 0.9),
                                        value: _checkRules,
                                        onChanged: (v) {
                                          setState(() {
                                            _checkRules = v ?? false;
                                          });
                                        }),
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    "کلیه ",
                                    style: TextStyle(
                                      color: App.theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                                      fontFamily: "IRANSansBold",
                                      fontSize: 10,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => push(context, RulesScreen()),
                                    child: Text(
                                      "شرایط و قوانین استفاده",
                                      style: TextStyle(
                                        color: App.theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                                        fontFamily: "IRANSansBold",
                                        fontSize: 10,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    " را مطالعه نموده و آن را میپذیرم.",
                                    style: TextStyle(
                                      color: App.theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                                      fontFamily: "IRANSansBold",
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    BlocBuilder<LoginBloc, LoginState>(
                      bloc: _bloc,
                      builder: (context, state) {
                        return BlockBtn(
                          onTap: _login,
                          text: "ارسال کد تایید",
                          height: 40,
                          radius: 5,
                          isLoading: state is LoginLoading,
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

  void _login() {
    String numberPhone = numberPhoneFieldController.value.text.replaceAll(' ', '');

    if (!numberPhone.isNotNullOrEmpty()) {
      return notify("شماره وارد نشده است.");
    }

    if (!_checkRules) {
      return notify("لطفا شرایط استفاده، قوانین و حریم خصوصی را مطالعه کنید");
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

class _LogoBackgroundWawe extends CustomPainter {
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
