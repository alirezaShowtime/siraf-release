import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/user.dart';
import 'package:siraf3/settings.dart';
import 'package:siraf3/themes.dart';

import '../widgets/app_bar_title.dart';
import '../widgets/my_back_button.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreen();

  User? user;

  SettingsScreen({required this.user});
}

class _SettingsScreen extends State<SettingsScreen> {
  bool showNumberPhoneForAgent = false;
  bool showNotification = false;
  bool darkMode = false;

  Settings settings = Settings();

  @override
  void initState() {
    super.initState();

    setData();
  }

  setData() async {
    showNumberPhoneForAgent = await settings.showNumberPhoneForAgent();
    showNotification = await settings.showNotification();
    darkMode = await settings.darkMode();

    setState(() {});
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
        titleSpacing: 0,
      ),
      body: ListView(
        children: [
          if (widget.user?.name != null)
            item(
              title: "نام و نام خانوادگی",
              text: widget.user?.name,
            ),
          if (widget.user?.username != null)
            item(
              title: "نام کاربری",
              text: widget.user?.username,
            ),
          if (widget.user?.phone != null) item(title: "شماره همراه", text: phoneFormat(widget.user!.phone!)),
          item(
            title: "نمایش شماره همراه برای مشاوران",
            widget: FlutterSwitch(
              height: 20.0,
              width: 40.0,
              padding: 4.0,
              toggleSize: 10.0,
              borderRadius: 10.0,
              activeColor: Themes.blue,
              inactiveColor: Colors.grey.shade300,
              value: showNumberPhoneForAgent,
              activeToggleColor: Colors.white,
              inactiveToggleColor: Themes.blue,
              onToggle: (value) {
                setState(() {
                  showNumberPhoneForAgent = value;
                });
                settings.setShowNumberPhoneForAgent(value);
              },
            ),
          ),
          item(
            title: "اعلان برنامه",
            widget: FlutterSwitch(
              height: 20.0,
              width: 40.0,
              padding: 4.0,
              toggleSize: 10.0,
              borderRadius: 10.0,
              activeColor: Themes.blue,
              inactiveColor: Colors.grey.shade300,
              value: showNotification,
              activeToggleColor: Colors.white,
              inactiveToggleColor: Themes.blue,
              onToggle: (value) {
                setState(() {
                  showNotification = value;
                });
                settings.setShowNotification(value);
              },
            ),
          ),
          item(
            title: "حالت شب",
            widget: FlutterSwitch(
              height: 20.0,
              width: 40.0,
              padding: 4.0,
              toggleSize: 10.0,
              borderRadius: 10.0,
              activeColor: Themes.blue,
              inactiveColor: Colors.grey.shade300,
              value: darkMode,
              activeToggleColor: Colors.white,
              inactiveToggleColor: Themes.blue,
              onToggle: (value) {
                setState(() {
                  darkMode = value;
                });
                settings.setDarkMode(value);
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
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
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
              style: TextStyle(fontSize: 13, color: Themes.text, fontFamily: "IranSansMedium"),
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
    Navigator.pop(context);
  }

  twoVerification() {
    //todo: set event listener
  }

  checkUpdate() {
    //todo: set event listener
  }
}
