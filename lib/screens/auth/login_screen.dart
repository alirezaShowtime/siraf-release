import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siraf3/bloc/login_status.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/screens/auth/verify_screen.dart';
import 'package:siraf3/screens/webview_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  bool pop;

  LoginScreen({this.pop = false, Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController mobileController = TextEditingController();
  String? _mobileError = null;
  String mobile = '';

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                "شماره موبایل خود را وارد کنید",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'شماره موبایل',
                  contentPadding: const EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Themes.primary, width: 1),
                  ),
                  errorText: _mobileError,
                  counterText: "",
                  suffixIcon: Icon(
                    Icons.phone,
                    color: Themes.primary,
                  ),
                ),
                maxLength: 11,
                maxLines: 1,
                textAlign: TextAlign.center,
                textInputAction: TextInputAction.send,
                onFieldSubmitted: (v) => login(),
                keyboardType: TextInputType.number,
                controller: mobileController,
                onSaved: (String? phone) {
                  this.mobile = phone ?? '';
                },
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
            SizedBox(height: 15),
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
                          onTap: login,
                          child: Container(
                            child: Text(
                              'ارسال کد فعالسازی',
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
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WebViewScreen(
                        title: 'قوانین مقررات',
                        url: 'https://article.siraf.biz/api/v1/rules'),
                  ),
                );
              },
              child: Text(
                "شرایط استفاده از خدمات، قوانین و حریم خصوصی",
                style: TextStyle(
                  color: Themes.primary,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void login() async {
    if (_formKey.currentState == null
        ? false
        : _formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      BlocProvider.of<LoginStatus>(context).add(true);

      var response = await http.post(createAuthUrlByEndPoint('login/'),
          body: jsonEncode({'mobile': mobile, 'type': 1}),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          });

      BlocProvider.of<LoginStatus>(context).add(false);

      var resBody = jDecode(response.body);

      print(resBody);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('mobile', mobile);

        notify(resBody['data'].toString(), duration: Duration(seconds: 3));

        var result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyScreen(
              pop: widget.pop,
              mobile: mobile,
            ),
          ),
        );
        if (widget.pop && result == 'ok_pop') {
          Navigator.pop(context, result);
        }
      } else if (response.statusCode == 400) {
        setState(() {
          _mobileError = resBody['message'];
        });
      } else {
        notify('خطای غیر منتظره ای رخ داد لطفا بعدا دوباره تلاش کنید');
      }
    }
  }
}
