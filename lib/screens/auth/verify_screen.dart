import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siraf3/bloc/login_status.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/user.dart';
import 'package:siraf3/screens/home_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:http/http.dart' as http;

class VerifyScreen extends StatefulWidget {
  bool pop;
  String mobile;
  String? verifyCode;
  VerifyScreen(
      {this.verifyCode, this.pop = false, required this.mobile, Key? key})
      : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  TextEditingController codeController = TextEditingController();
  String? _codeError = null;
  String code = '';

  late String mobile;

  late Timer _timer;
  late int _timeLeft;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _getMobile();

    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Color(0xff0067a5),
              ),
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(bottom: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image(
                    image: AssetImage("assets/images/siraf.png"),
                    height: 80,
                    width: 80,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          CupertinoIcons.back,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        width: 40,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "لطفا کد فعالسازی که به شماره ${widget.mobile} ارسال شده را وارد کنید",
                style: TextStyle(
                  color: App.theme.textTheme.bodyLarge?.color,
                  fontSize: 13.5,
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                children: [
                  TextFormField(
                    maxLines: 1,
                    onSaved: (String? code) {
                      this.code = code ?? '';
                    },
                    validator: (String? code) {
                      if (code == null || code.trim().isEmpty) {
                        return 'کد تایید را وارد کنید';
                      }
                    },
                    keyboardType: TextInputType.number,
                    controller: codeController,
                    decoration: InputDecoration(
                      hintText: 'کد ارسالی',
                      contentPadding: const EdgeInsets.all(8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: App.theme.tooltipTheme.textStyle?.color ??
                              Colors.grey,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Themes.primary, width: 1),
                      ),
                      errorText: _codeError,
                      counterText: "",
                      hintStyle: TextStyle(
                        color: App.theme.tooltipTheme.textStyle?.color,
                      ),
                    ),
                    style: TextStyle(
                      color: App.theme.textTheme.bodyLarge?.color,
                    ),
                    textAlign: TextAlign.center,
                    textInputAction: TextInputAction.send,
                    onFieldSubmitted: (v) => verify(),
                  ),
                  Positioned(
                    left: 10,
                    top: 10,
                    bottom: 10,
                    child: Icon(
                      Icons.phone,
                      color: Themes.primary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            MaterialButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'تغییر شماره',
                style: TextStyle(
                  color: Themes.primary.withOpacity(0.8),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            BlocBuilder<LoginStatus, bool>(
              builder: (context, bool status) {
                return status
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          child: SpinKitCircle(
                            color: Colors.white,
                            size: 40,
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              color: Themes.primary,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: GestureDetector(
                          onTap: verify,
                          child: Container(
                            child: Text(
                              'ورود',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                                color: Themes.primary,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      );
              },
            ),
            SizedBox(height: 25),
            MaterialButton(
              onPressed: _timeLeft == 0 ? _onSendCodeAgain : null,
              child: Text(
                'ارسال مجدد کد' + (_timeLeft == 0 ? '' : ' (${_timeLeft})'),
                style: TextStyle(
                  color: Themes.primary.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSendCodeAgain() async {
    var response = await http.post(createAuthUrlByEndPoint('login/'),
        body: jsonEncode({'mobile': mobile, 'type': 1}),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        });

    var resBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      notify(resBody['data'].toString());
      _startTimer();
      notify("کد تایید مجدد ارسال شد");
    } else {
      notify('خطای غیر منتظره ای رخ داد لطفا بعدا دوباره تلاش کنید');
    }
  }

  void _getMobile() async {
    final prefs = await SharedPreferences.getInstance();
    String? mobile = await prefs.getString('mobile');
    if (mobile == null) {
      Navigator.pop(context);
      return;
    }

    this.mobile = mobile;
  }

  void verify() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final url = createAuthUrlByEndPoint('confirm/');

      BlocProvider.of<LoginStatus>(context).add(true);

      var response = await http.post(url,
          body: jsonEncode({'mobile': mobile, 'code': code}),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          });

      BlocProvider.of<LoginStatus>(context).add(false);

      var resBody = jDecode(response.body);

      print(resBody);

      if (response.statusCode == 200) {
        var user = User.fromJson(resBody['data']['user']);

        user.token = resBody['data']['token']['access'];
        user.refreshToken = resBody['data']['token']['refresh'];
        user.save();
        if (widget.pop) {
          Navigator.pop(context, 'ok_pop');
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => HomeScreen()),
              (Route<dynamic> route) => false);
        }
      } else if (response.statusCode == 400) {
        setState(() {
          _codeError = resBody['message'];
        });
      } else {
        notify('خطای غیر منتظره ای رخ داد لطفا بعدا دوباره تلاش کنید');
      }
    }
  }

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

  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
