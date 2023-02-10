import 'package:flutter/material.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/user.dart';
import 'package:siraf3/settings.dart';
import 'package:siraf3/themes.dart';
import 'package:switcher_button/switcher_button.dart';

import '../widgets/app_bar_title.dart';
import '../widgets/my_back_button.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreen();

  User user;

  SettingsScreen({required this.user});
}

class _SettingsScreen extends State<SettingsScreen> {
  bool? showNumberPhoneForAgent;
  bool? showNotification;
  bool? darkMode;

  @override
  void initState() {
    Settings.showNumberPhoneForAgent.then((value) {
      showNumberPhoneForAgent = value;
      setState(() {});
    });

    Settings.showNotification.then((value) {
      showNotification = value;
      setState(() {});
    });

    Settings.darkMode.then((value) {
      darkMode = value;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Themes.background,
      appBar: AppBar(
        backgroundColor: Themes.appBar,
        elevation: 0.7,
        automaticallyImplyLeading: false,
        leading: MyBackButton(),
        title: AppBarTitle("تنظیمات"),
        actions: [
          TextButton(
            onPressed: logout,
            child: Text(
              "خروج",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          item(
            title: "نام و نام خانوادگی",
            text: widget.user.name,
          ),
          item(
            title: "نام کاربری",
            text: widget.user.username,
          ),
          item(
            title: "شماره همراه",
            text: widget.user.phone != null
                ? phoneFormat(widget.user.phone!)
                : "",
          ),
          item(
            title: "نمایش شماره همراه برای مشاوران",
            widget: SwitcherButton(
              onColor: Themes.blue,
              offColor: Colors.grey.shade300,
              value: showNumberPhoneForAgent ?? false,
              onChange: (value) {
                Settings.toggleShowNumberPhoneForAgent();
              },
            ),
          ),
          item(
            title: "اعلان برنامه",
            widget: SwitcherButton(
              onColor: Themes.blue,
              offColor: Colors.grey.shade300,
              value: showNotification ?? true,
              onChange: (value) {
                Settings.toggleShowNotification();
              },
            ),
          ),
          item(
            title: "حالت شب",
            widget: SwitcherButton(
              onColor: Themes.blue,
              offColor: Colors.grey.shade300,
              value: darkMode ?? false,
              onChange: (value) {
                Settings.toggleDarkMode();
              },
            ),
          ),
          item(
            title: "تایید دو مرحله‌ای",
            widget: Text(
              "تعیین",
              style: TextStyle(
                color: Themes.blue,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: twoVerification,
          ),
          item(
            title: "نسخه برنامه(3.0.0)",
            widget: Text(
              "بررسی بروزرسانی",
              style: TextStyle(
                color: Themes.blue,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: checkUpdate,
          ),
        ],
      ),
    );
  }

  Widget item({required String title, String? text, Widget? widget, GestureTapCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 13, color: Themes.text, fontWeight: FontWeight.bold),
            ),
            if (text != null && widget == null)
              Text(
                text,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontSize: 11,
                  color: Themes.text.withOpacity(0.7),
                ),
              ),
            if (widget != null && text == null) widget
          ],
        ),
      ),
    );
  }

  //onClick Listeners
  logout() {
    //todo: set event listener
    User.remove();
  }

  twoVerification() {
    //todo: set event listener
  }

  checkUpdate() {
    //todo: set event listener
  }
}
