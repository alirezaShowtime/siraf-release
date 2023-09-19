import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siraf3/bloc/auth/edit_profile_bloc.dart';
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
import 'package:siraf3/utilities/get_last_version.dart';
import 'package:siraf3/widgets/confirm_dialog.dart';
import 'package:siraf3/widgets/my_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:siraf3/http2.dart' as http2;

import '../widgets/app_bar_title.dart';
import '../widgets/my_back_button.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreen();

  User? user;

  SettingsScreen({required this.user});
}

class _SettingsScreen extends State<SettingsScreen> {
  bool showNumberPhoneForConsultant = false;
  bool showNotification = false;
  bool darkMode = false;

  late DarkThemeProvider darkThemeProvider;

  Settings settings = Settings();
  EditProfileBloc editProfileBloc = EditProfileBloc();

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
          if (event.isRequired) {
            animationDialog(
                context: context,
                builder: (dialogContext) {
                  return ConfirmDialog(
                    dialogContext: dialogContext,
                    title: "بروزرسانی",
                    content: "نسخه جدیدی از برنامه منتشر شده است.",
                    applyText: "بروزرسانی",
                    cancelText: "خروج از برنامه",
                    onApply: () => GetLastVersion.start(event.downloadUrl),
                    onCancel: applicationExit,
                  );
                });
          } else {
            showDialog2(
              context: context,
              barrierDismissible: true,
              builder: (_context) {
                return ConfirmDialog(
                  dialogContext: context,
                  content: "نسخه جدیدی از برنامه موجود است آیا میخواهید بروزرسانی کنید؟",
                  applyText: "بله",
                  cancelText: "خیر",
                  onApply: () => GetLastVersion.start(event.downloadUrl),
                  title: "بروزرسانی",
                );
              },
            );
          }
        } else {
          setState(() {
            isLastVersion = true;
          });
          notify("آخرین نسخه برنامه نصب می باشد");
        }
      }
    });

    editProfileBloc.stream.listen((event) {
      if (event is EditProfileLoadingState) {
        loadingDialog(context: context, showMessage: false);
      } else if (event is EditProfileErrorState) {
        dismissDialog(loadingDialogContext);

        notify("خطایی پیش آمد مجدد تلاش کنید");
        setState(() {
          showNumberPhoneForConsultant = !showNumberPhoneForConsultant;
        });
      } else if (event is EditProfileSuccessState) {
        dismissDialog(loadingDialogContext);
      }
    });
  }

  setData() async {
    showNumberPhoneForConsultant = !((await User.fromLocal()).privateMobile ?? false);
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
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
              onPressed: logout,
              icon: Text(
                "خروج",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 11,
                  fontFamily: "IranSansBold",
                ),
              ),
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
                      text: widget.user!.name.isNotNullOrEmpty() ? widget.user!.name! : "وارد نشده",
                      style: TextStyle(fontSize: 11, fontFamily: "IranSansMedium", color: App.theme.textTheme.bodyLarge?.color),
                    ),
                    TextSpan(
                      text: " (ویرایش)",
                      style: TextStyle(
                        fontSize: 11,
                        color: App.theme.primaryColor,
                        fontFamily: "IranSansMedium",
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          if (widget.user?.phone != null) item(title: "شماره همراه", text: phoneFormat(widget.user!.phone!)),
          if (widget.user?.phone != null)
            item(
              title: "نمایش شماره همراه برای مشاوران",
              widget: FlutterSwitch(
                height: 20.0,
                width: 40.0,
                padding: 4.0,
                toggleSize: 10.0,
                borderRadius: 10.0,
                activeColor: App.theme.primaryColor,
                inactiveColor: Colors.grey.shade300,
                value: showNumberPhoneForConsultant,
                activeToggleColor: Colors.white,
                inactiveToggleColor: App.theme.primaryColor,
                onToggle: (value) {
                  setState(() {
                    showNumberPhoneForConsultant = value;
                  });

                  editProfileBloc.add(EditProfileEvent(mobilePrivate: !value));
                },
              ),
            ),
          if (widget.user?.id != null)
            item(
              title: "اعلان برنامه",
              widget: MySwitch(
                value: showNotification,
                onToggle: (value) async {
                  setState(() => showNotification = value);
                  settings.setShowNotification(value);

                  if (value) {
                    await Firebase.initializeApp();
                    http2.postJsonWithToken(
                      Uri.parse("https://message.siraf.app/api/fireBase/addDevice/"),
                      body: {
                        "token": (await FirebaseMessaging.instance.getToken()).toString(),
                        "userId": widget.user!.id,
                      },
                    );
                  } else {
                    FirebaseMessaging.instance.deleteToken();
                  }
                },
              ),
            ),
          item(
            title: "حالت شب",
            widget: MySwitch(
              value: darkMode,
              onToggle: (value) {
                setState(() => darkMode = value);
                darkThemeProvider.darkTheme = value;

                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                  statusBarColor: darkMode ? DarkThemes.appBar : Themes.appBar,
                  statusBarBrightness: darkMode ? Brightness.light : Brightness.dark,
                  statusBarIconBrightness: darkMode ? Brightness.light : Brightness.dark,
                  systemNavigationBarDividerColor: darkMode ? Color.fromARGB(255, 82, 82, 82) : Color.fromARGB(255, 235, 234, 234),
                  systemNavigationBarIconBrightness: darkMode ? Brightness.light : Brightness.dark,
                  systemNavigationBarColor: darkMode ? DarkThemes.appBar : Themes.appBar,
                ));
              },
            ),
          ),
          item(
            title: "نمایش فایل ها به صورت اسلایدی",
            widget: MySwitch(
              value: isSlideViewType,
              onToggle: (value) async {
                await changeViewType(value);
                pushAndRemoveUntil(context, HomeScreen());
              },
            ),
          ),
          // item(
          //   title: "تایید دو مرحله‌ای",
          //   widget: Text(
          //     "تعیین",
          //     style: TextStyle(
          //       color: Themes.blue,
          //       fontSize: 11,
          //       fontFamily: "IranSansBold",
          //     ),
          //   ),
          //   onTap: twoVerification,
          // ),
          item(
            title: "نسخه برنامه(3.0.0)",
            widget: Text(
              isLastVersion ? "آخرین نسخه نصب میباشد" : "بررسی بروزرسانی",
              style: TextStyle(
                color: isLastVersion ? App.theme.textTheme.bodyLarge?.color : App.theme.primaryColor,
                fontSize: 11,
                fontFamily: "IranSansBold",
              ),
            ),
            onTap: isLastVersion ? () {} : checkUpdate,
          ),
        ],
      ),
    );
  }

  bool isLastVersion = false;

  Widget item({required String title, String? text, Widget? widget, GestureTapCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: App.theme.shadowColor.withOpacity(0.4),
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
    animationDialog(
      context: context,
      builder: (_) => ConfirmDialog(
        dialogContext: context,
        content: "آیا مایل به خروج از حساب خود هستید؟",
        title: "خروج",
        titleColor: Colors.red,
        applyText: "بله",
        cancelText: "خیر",
        onApply: () {
          Navigator.pop(_);
          FirebaseMessaging.instance.deleteToken();
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
