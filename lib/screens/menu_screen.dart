import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/models/user.dart';
import 'package:siraf3/screens/auth/login_screen.dart';
import 'package:siraf3/screens/create/create_file_first.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/accordion.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

import '../helpers.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int openedItem = -1;
  User? user;

  @override
  void initState() {
    super.initState();

    getUser();
  }

  getUser() async {
    var user = await User.fromLocal();
    setState(() {
      this.user = user;
    });

    print(user.profileSource);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height / 2.5;

    return Scaffold(
      backgroundColor: Themes.background,
      body: SafeArea(
        child: ColoredBox(
          color: Colors.grey.shade100,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width / 3 * 2.075,
                    padding: EdgeInsets.only(bottom: 50),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/menu_background.png"),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Themes.primary,
                          BlendMode.hardLight,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ClipRRect(
                          child: Image(
                            image: NetworkImage(
                                getImageUrl(user?.profileSource ?? "")),
                            errorBuilder: (context, error, stackTrace) => Image(
                              image: AssetImage("assets/images/profile.png"),
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (user == null || user!.phoneNumber == null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LoginScreen(),
                                ),
                              );
                            }
                          },
                          child: Text(
                            user?.fullName ?? "ورود به حساب",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        Text(
                          user?.phoneNumber != null
                              ? phoneFormat(user!.phoneNumber!)
                              : "",
                          textDirection: TextDirection.ltr,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -30),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Wrap(
                        children: [
                          _item(
                            title: "پیام ها",
                            icon: CupertinoIcons.envelope,
                            onClick: () {},
                          ),
                          _item(
                            title: "ثبت فایل",
                            icon: CupertinoIcons.add,
                            onClick: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CreateFileFirst(),
                                ),
                              );
                            },
                          ),
                          _item(
                            title: "نشان ها",
                            icon: CupertinoIcons.bookmark,
                            onClick: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        Accordion(
                          title: _accordionTitle("فایل ها و در خواست ها"),
                          onClick: () {
                            _onClickAccordion(0);
                          },
                          open: openedItem == 0,
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AccordionItem(
                                  onClick: () {}, title: "فایل های من"),
                              AccordionItem(
                                  onClick: () {}, title: "ثبت در خواست"),
                              AccordionItem(
                                  onClick: () {}, title: "در خواست های من"),
                              AccordionItem(
                                  onClick: () {}, title: "ملک های اطراف من"),
                            ],
                          ),
                        ),
                        Accordion(
                          title: _accordionTitle("دفاتر املاک"),
                          onClick: () {
                            _onClickAccordion(1);
                          },
                          open: openedItem == 1,
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AccordionItem(
                                  onClick: () {},
                                  title: "دفاتر املاک اطراف من"),
                              AccordionItem(
                                  onClick: () {}, title: "ثبت دفتر املاک"),
                            ],
                          ),
                        ),
                        Accordion(
                          title: _accordionTitle("استعلامات"),
                          onClick: () {
                            _onClickAccordion(2);
                          },
                          open: openedItem == 2,
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AccordionItem(
                                  onClick: () {}, title: "استعلامات ثبتی"),
                              AccordionItem(
                                  onClick: () {}, title: "استعلامات قرارداد"),
                            ],
                          ),
                        ),
                        Accordion(
                          title: _accordionTitle("محاسبات"),
                          onClick: () {
                            _onClickAccordion(3);
                          },
                          open: openedItem == 3,
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AccordionItem(
                                  onClick: () {}, title: "محاسبه کمیسیون"),
                              AccordionItem(
                                  onClick: () {}, title: "تبدیل رهن به اجاره"),
                            ],
                          ),
                        ),
                        Accordion(
                          title: _accordionTitle("پشتیبانی"),
                          onClick: () {
                            _onClickAccordion(4);
                          },
                          open: openedItem == 4,
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AccordionItem(
                                  onClick: () {},
                                  title: "پشتیبانی ثبت فایل و درخواست"),
                              AccordionItem(
                                  onClick: () {},
                                  title: "پشتیبانی فروش و بازاریابی"),
                              AccordionItem(
                                  onClick: () {}, title: "پشتیبانی فنی"),
                              AccordionItem(
                                  onClick: () {}, title: "گزارشات و پیشنهادات"),
                              AccordionItem(
                                  onClick: () {}, title: "در خواست همکاری"),
                            ],
                          ),
                        ),
                        Card(
                          elevation: 0,
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 15),
                              child: Text(
                                "درباره سیراف و قوانین استفاده",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey.shade500),
                              ),
                            ),
                          ),
                        ),
                        Card(
                          elevation: 0,
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 15),
                              child: Text(
                                "معرفی برنامه به دیگران(${VERSION})",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey.shade500),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        CupertinoIcons.back,
                        color: Themes.iconLight,
                        size: 20,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        CupertinoIcons.settings,
                        color: Themes.iconLight,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onClickAccordion(int item) {
    if (openedItem == item) return;

    setState(() {
      openedItem = item;
    });
  }

  Widget _accordionTitle(String title) {
    return Text(title,
        style: TextStyle(color: Colors.grey.shade500, fontSize: 15));
  }

  Widget _item({
    required String title,
    required IconData icon,
    required GestureTapCallback onClick,
  }) {
    return GestureDetector(
      onTap: onClick,
      child: Padding(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: Column(
          children: [
            Icon(
              icon,
              size: 27,
              color: Themes.icon,
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
