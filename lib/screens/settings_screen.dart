import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:siraf3/bloc/check_version_bloc.dart';
import 'package:siraf3/dark_theme_provider.dart';
import 'package:siraf3/dark_themes.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/user.dart';
import 'package:siraf3/screens/auth/edit_profile_screen.dart';
import 'package:siraf3/screens/home_screen.dart';
import 'package:siraf3/settings.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/confirm_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/app_bar_title.dart';
import '../widgets/my_back_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  late DarkThemeProvider darkThemeProvider;

  Settings settings = Settings();

  @override
  void initState() {
    super.initState();

    setData();

    checkVersionBloc.stream.listen((event) {
      if (event is CheckVersionLoadingState) {
        loadingDialog(context: context, showMessage: false);
      }
      if (event is CheckVersionErrorState) {
        dismissDialog(loadingDialogContext);

        notify("خطا در دریافت اطلاعات لطفا مجدد تلاش کنید");
      }
      if (event is CheckVersionSuccessState) {
        dismissDialog(loadingDialogContext);
        if (event.hasUpdate) {
          showDialog2(
            context: context,
            barrierDismissible: true,
            builder: (_context) {
              return ConfirmDialog(
                dialogContext: context,
                content:
                    "نسخه جدیدی از برنامه موجود است آیا میخواهید بروزرسانی کنید؟",
                applyText: "بله",
                cancelText: "خیر",
                onApply: () => openBazarOrOpenUrl(event.downloadUrl),
                title: "بروزرسانی",
              );
            },
          );
        } else {
          setState(() {
            isLastVersion = true;
          });
          notify("آخرین نسخه برنامه نصب می باشد");
        }
      }
    });
  }

  setData() async {
    showNumberPhoneForAgent = await settings.showNumberPhoneForAgent();
    showNotification = await settings.showNotification();
    darkMode = await settings.darkMode();

    setViewType();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    darkThemeProvider = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
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
          if (widget.user!.id != null)
            item(
                title: "نام و نام خانوادگی",
                widget: GestureDetector(
                    onTap: editProfile,
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: widget.user!.name.isNotNullOrEmpty()
                              ? widget.user!.name!
                              : "وارد نشده",
                          style: TextStyle(
                              fontSize: 11,
                              fontFamily: "IranSansMedium",
                              color: App.theme.textTheme.bodyLarge?.color),
                        ),
                        TextSpan(
                          text: " (ویرایش)",
                          style: TextStyle(
                              fontSize: 11,
                              color: App.theme.primaryColor,
                              fontFamily: "IranSansMedium"),
                        ),
                      ]),
                    ))),
          if (widget.user?.phone != null)
            item(title: "شماره همراه", text: phoneFormat(widget.user!.phone!)),
          // item(
          //   title: "نمایش شماره همراه برای مشاوران",
          //   widget: FlutterSwitch(
          //     height: 20.0,
          //     width: 40.0,
          //     padding: 4.0,
          //     toggleSize: 10.0,
          //     borderRadius: 10.0,
          //     activeColor: Themes.blue,
          //     inactiveColor: Colors.grey.shade300,
          //     value: showNumberPhoneForAgent,
          //     activeToggleColor: Colors.white,
          //     inactiveToggleColor: Themes.blue,
          //     onToggle: (value) {
          //       setState(() {
          //         showNumberPhoneForAgent = value;
          //       });
          //       settings.setShowNumberPhoneForAgent(value);
          //     },
          //   ),
          // ),

          if (widget.user!.id != null)
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

                darkThemeProvider.darkTheme = value;

                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                  statusBarColor: darkMode ? DarkThemes.appBar : Themes.appBar,
                  statusBarBrightness:
                      darkMode ? Brightness.light : Brightness.dark,
                  statusBarIconBrightness:
                      darkMode ? Brightness.light : Brightness.dark,
                  systemNavigationBarIconBrightness:
                      darkMode ? Brightness.light : Brightness.dark,
                  systemNavigationBarColor:
                      darkMode ? DarkThemes.appBar : Themes.appBar,
                ));
              },
            ),
          ),
          item(
            title: "نمایش فایل ها به صورت اسلایدی",
            widget: FlutterSwitch(
              height: 20.0,
              width: 40.0,
              padding: 4.0,
              toggleSize: 10.0,
              borderRadius: 10.0,
              activeColor: Themes.blue,
              inactiveColor: Colors.grey.shade300,
              value: isSlideViewType,
              activeToggleColor: Colors.white,
              inactiveToggleColor: Themes.blue,
              onToggle: (value) async {
                await changeViewType(value);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                    (route) => false);
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
            title:
                "نسخه برنامه(3.0.0)",
            widget: Text(
              isLastVersion ? "آخرین نسخه نصب میباشد" : "بررسی بروزرسانی",
              style: TextStyle(
                color: isLastVersion ? Themes.text : Themes.blue,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: isLastVersion ? () {} : checkUpdate,
          ),
        ],
      ),
    );
  }

  bool isLastVersion = false;

  Widget item(
      {required String title,
      String? text,
      Widget? widget,
      GestureTapCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade200.withOpacity(0.4),
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
              style: TextStyle(fontSize: 13, fontFamily: "IranSansMedium"),
            ),
            if (text != null && widget == null)
              Text(
                text,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  fontSize: 11,
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
    showDialog2(
      context: context,
      builder: (_) => ConfirmDialog(
        dialogContext: context,
        content: "از مایل به خروج از حساب هستید؟",
        title: "خروج",
        titleColor: Colors.red,
        applyText: "خروج",
        onApply: () {
          Navigator.pop(_);
          User.remove();
          Navigator.pop(context);
        },
      ),
    );
  }

  twoVerification() {
    //todo: set event listener
  }

  checkUpdate() {
    checkVersionBloc.add(CheckVersionEvent());
  }

  CheckVersionBloc checkVersionBloc = CheckVersionBloc();

  void editProfile() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfileScreen()));

    getUser();
  }

  void showEditUserNameDialog() {
    //todo: set event listener
  }

  changeViewType(bool value) async {
    var sh = await SharedPreferences.getInstance();
    sh.setString("FILE_VIEW_TYPE", value ? "slide" : "list");

    setState(() {
      isSlideViewType = value;
    });
  }

  setViewType() async {
    var sh = await SharedPreferences.getInstance();
    var t = sh.getString("FILE_VIEW_TYPE") ?? "list";

    print(t);

    setState(() {
      isSlideViewType = t == "slide";
    });
  }

  bool isSlideViewType = false;

  openBazarOrOpenUrl(String downloadUrl) async {
    if (await canLaunchUrl(Uri.parse("bazaar://details?id=app.siraf"))) {
      launchUrl(Uri.parse("bazaar://details?id=app.siraf"));
    } else if (await canLaunchUrl(Uri.parse(downloadUrl))) {
      launchUrl(Uri.parse(downloadUrl), mode: LaunchMode.externalApplication);
    }
  }
  
  void getUser() async {
    widget.user = await User.fromLocal();
    setState(() {});
  }
}
