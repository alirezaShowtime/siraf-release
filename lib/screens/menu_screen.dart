import 'dart:async';

import 'package:badges/badges.dart' as badge;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:siraf3/bloc/ticket/get_groups_bloc.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/dark_themes.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/user.dart';
import 'package:siraf3/rabbit_mq_data.dart';
import 'package:siraf3/screens/auth/edit_profile_screen.dart';
import 'package:siraf3/screens/auth/login_screen.dart';
import 'package:siraf3/screens/bookmark_screen.dart';
import 'package:siraf3/screens/chat/chat_list_screen.dart';
import 'package:siraf3/screens/commission_calculator_screen.dart';
import 'package:siraf3/screens/create/create_file_first.dart';
import 'package:siraf3/screens/estates_map_screen.dart';
import 'package:siraf3/screens/files_map_screen.dart';
import 'package:siraf3/screens/inquiry_screen.dart';
import 'package:siraf3/screens/my_files_screen.dart';
import 'package:siraf3/screens/request_file/request_file_screen.dart';
import 'package:siraf3/screens/request_file/request_list_screen.dart';
import 'package:siraf3/screens/rules_screen.dart';
import 'package:siraf3/screens/settings_screen.dart';
import 'package:siraf3/screens/ticket/ticket_creation_screen.dart';
import 'package:siraf3/screens/ticket/ticket_list_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/accordion.dart';
import 'package:siraf3/widgets/avatar.dart';
import 'package:siraf3/widgets/my_icon_button.dart';

import '../helpers.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int openedItem = -1;
  User? user;
  bool disposed = false;

  @override
  void initState() {
    super.initState();

    getUser();

    getGroupsBloc.add(GetGroupsEvent());

    listenRabbitData();
  }

  @override
  void dispose() {
    super.dispose();
    disposed = true;
    getGroupsBloc.close();
  }

  getUser() async {
    var user = await User.fromLocal();
    setState(() {
      this.user = user;
    });
  }

  GetGroupsBloc getGroupsBloc = GetGroupsBloc();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height / 2.5;

    return BlocProvider(
      create: (_) => getGroupsBloc,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          body: ColoredBox(
            color: App.theme.backgroundColor,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width / 3 * 2.075,
                      padding: EdgeInsets.only(bottom: 60),
                      margin: EdgeInsets.only(bottom: 50),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/menu_background.png"),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            App.isDark ? DarkThemes.background : Themes.primary,
                            BlendMode.hardLight,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await doWithLogin(context, () async {
                                await Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfileScreen()));
                                getUser();
                              });

                              getUser();
                            },
                            child: ClipRRect(
                              child: Hero(
                                tag: 'profileImage',
                                child: Avatar(
                                  image: NetworkImage(user?.avatar ?? ""),
                                  errorWidget: _profileWidget(),
                                  loadingWidget: _profileWidget(),
                                  size: 80,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (user == null || user!.phone == null) {
                                await push(context, LoginScreen());
                                getUser();
                              }
                            },
                            child: Text(
                              user?.token != null ? (user?.name ?? "") : "ورود به حساب",
                              style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "IranSansMedium"),
                            ),
                          ),
                          Text(
                            user?.phone != null ? phoneFormat(user!.phone!) : "",
                            textDirection: TextDirection.ltr,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top,
                      left: 7,
                      right: 7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyIconButton(
                            onTap: () => Navigator.pop(context),
                            icon: Icon(CupertinoIcons.back, color: Themes.iconLight, size: 20),
                          ),
                          MyIconButton(
                            onTap: () async {
                              await push(context, SettingsScreen(user: user));
                              getUser();
                            },
                            icon: Icon(CupertinoIcons.settings, color: Themes.iconLight, size: 20),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            color: App.theme.dialogBackgroundColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _item(
                                    title: "پیام ها",
                                    icon: CupertinoIcons.envelope,
                                    hasBadge: hasNewMessage,
                                    onClick: () {
                                      if (hasNewMessage) {
                                        setState(() => hasNewMessage = false);
                                        hasNewMessageStream.add(hasNewMessage);
                                      }
                                      doWithLogin(context, () => push(context, ChatListScreen()));
                                    },
                                  ),
                                  _item(
                                    title: "ثبت فایل",
                                    icon: CupertinoIcons.add,
                                    onClick: () async {
                                      await doWithLogin(context, () => push(context, CreateFileFirst()));
                                      getUser();
                                    },
                                  ),
                                  _item(
                                    title: "نشان ها",
                                    icon: CupertinoIcons.bookmark,
                                    onClick: () => doWithLogin(context, () => push(context, BookmarkScreen())),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView(
                      children: [
                        Accordion(
                          title: _accordionTitle("فایل ها و در خواست ها"),
                          onClick: () => _onClickAccordion(0),
                          open: openedItem == 0,
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AccordionItem(
                                title: "فایل های من",
                                onClick: () async {
                                  await doWithLogin(context, () => push(context, MyFilesScreen()));
                                  getUser();
                                },
                              ),
                              AccordionItem(
                                title: "ثبت در خواست",
                                onClick: () async {
                                  await doWithLogin(context, () => push(context, RequestFileScreen()));

                                  getUser();
                                },
                              ),
                              AccordionItem(
                                title: "در خواست های من",
                                onClick: () async {
                                  await doWithLogin(context, () => push(context, RequestListScreen()));

                                  getUser();
                                },
                              ),
                              AccordionItem(
                                title: "ملک های اطراف من",
                                onClick: () => push(context, FilesMapScreen()),
                              ),
                            ],
                          ),
                        ),
                        Accordion(
                          title: _accordionTitle("دفاتر املاک"),
                          onClick: () => _onClickAccordion(1),
                          open: openedItem == 1,
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AccordionItem(
                                title: "دفاتر املاک اطراف من",
                                onClick: () => push(context, EstatesMapScreen()),
                              ),
                            ],
                          ),
                        ),
                        Accordion(
                          title: _accordionTitle("استعلامات"),
                          onClick: () => _onClickAccordion(2),
                          open: openedItem == 2,
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AccordionItem(
                                title: "استعلامات ثبتی",
                                onClick: () => push(context, InquiryScreen()),
                              ),
                            ],
                          ),
                        ),
                        Accordion(
                          title: _accordionTitle("محاسبات"),
                          onClick: () => _onClickAccordion(3),
                          open: openedItem == 3,
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AccordionItem(
                                title: "محاسبه کمیسیون",
                                onClick: () => push(context, CommissionCalculatorScreen()),
                              ),
                              AccordionItem(
                                title: "تبدیل رهن به اجاره",
                                onClick: () => push(context, CommissionCalculatorScreen()),
                              ),
                            ],
                          ),
                        ),
                        Accordion(
                          title: _accordionTitle("پشتیبانی"),
                          onClick: () => _onClickAccordion(4),
                          open: openedItem == 4,
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AccordionItem(
                                title: "تیکت های من",
                                onClick: () async {
                                  await doWithLogin(context, () => push(context, TicketListScreen()));
                                  getUser();
                                },
                              ),
                            ],
                          ),
                          // content: BlocBuilder<GetGroupsBloc, GetGroupsState>(builder: _buildTicketAccordionContent),
                        ),
                        Accordion(
                          title: _accordionTitle("درباره سیراف و قوانین استفاده"),
                          onClick: () => push(context, RulesScreen()),
                        ),
                        Accordion(
                          title: _accordionTitle("معرفی برنامه به دیگران(${VERSION})"),
                          onClick: () async {
                            await FlutterShare.share(
                              title: 'اشتراک گذاری برنامه',
                              text: "اپلیکیشن سیراف",
                              linkUrl: "https://siraf.app/app",
                              chooserTitle: 'اشتراک گذاری در',
                            );
                          },
                        ),
                        /*
                        GestureDetector(
                          onTap: () => push(context, RulesScreen()),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 5),
                            padding: EdgeInsets.only(bottom: 11, top: 11, right: 7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: App.theme.dialogBackgroundColor,
                            ),
                            child: Text(
                              "درباره سیراف و قوانین استفاده",
                              style: TextStyle(fontSize: 13, fontFamily: "IranSansBold"),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await FlutterShare.share(
                              title: 'اشتراک گذاری برنامه',
                              text: "اپلیکیشن سیراف",
                              linkUrl: "https://siraf.app/app",
                              chooserTitle: 'اشتراک گذاری در',
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 5),
                            padding: EdgeInsets.only(bottom: 11, top: 11, right: 7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: App.theme.dialogBackgroundColor,
                            ),
                            child: Text(
                              "معرفی برنامه به دیگران(${VERSION})",
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: "IranSansBold",
                              ),
                            ),
                          ),
                        ),
                        */
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileWidget() {
    return Container(
      color: Themes.primary.withOpacity(0.7),
      width: 80,
      height: 80,
      alignment: Alignment.center,
      child: Icon(Icons.person_rounded, color: Colors.white, size: 34),
    );
  }

  void _onClickAccordion(int item) {
    if (openedItem == item) return;

    setState(() {
      openedItem = item;
    });
  }

  Widget _accordionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 12, fontFamily: "IranSansBold"),
    );
  }

  Widget _item({required String title, required IconData icon, required GestureTapCallback onClick, bool hasBadge = false}) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      color: Colors.transparent,
      child: Container(
        height: 60,
        width: 60,
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onClick,
          child: Container(
            color: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                badge.Badge(
                  badgeContent: Text(''),
                  showBadge: hasBadge,
                  position: badge.BadgePosition.custom(top: -13, start: -6),
                  badgeStyle: badge.BadgeStyle(badgeColor: Themes.primary),
                  child: Icon(icon, size: 24, color: App.theme.iconTheme.color),
                ),
                SizedBox(height: 1),
                Text(title, style: TextStyle(fontSize: 10, fontFamily: "IranSansBold")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTicketAccordionContent(BuildContext context, GetGroupsState state) {
    if (state is GetGroupsLoadedState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
              AccordionItem(
                title: "تیکت های من",
                onClick: () async {
                  await doWithLogin(context, () => push(context, TicketListScreen()));
                  getUser();
                },
              ),
            ] +
            state.groups.map<Widget>((e) {
              return AccordionItem(
                title: e.name ?? "",
                onClick: () {
                  doWithLogin(context, () => push(context, TicketCreationScreen(group: e)));
                },
              );
            }).toList(),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AccordionItem(
          title: "تیکت های من",
          onClick: () {
            doWithLogin(context, () => push(context, TicketListScreen()));
          },
        ),
      ],
    );
  }

  void listenRabbitData() {
    hasNewMessageStream.close();
    hasNewMessageStream = StreamController<bool>();

    hasNewMessageStream.stream.listen((event) {
      setState(() {});
    });
  }
}
