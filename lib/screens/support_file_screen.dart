import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart';
import 'package:siraf3/bloc/chat/create/create_chat_bloc.dart';
import 'package:siraf3/bloc/file_consulants_bloc.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/file_consulant.dart';
import 'package:siraf3/models/file_detail.dart' as file_detail;
import 'package:siraf3/models/user.dart';
import 'package:siraf3/screens/agent_profile/agent_profile_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/try_again.dart';

import '../helpers.dart';

class SupportFileScreen extends StatefulWidget {
  bool isFavorite;
  int id;

  @override
  State<StatefulWidget> createState() => _SupportFileScreen();

  SupportFileScreen({required this.file, required this.isFavorite, required this.id});

  file_detail.FileDetail file;
}

class _SupportFileScreen extends State<SupportFileScreen> {
  FileConsulantsBloc bloc = FileConsulantsBloc();
  CreateChatBloc createChatBloc = CreateChatBloc();

  @override
  void dispose() {
    super.dispose();

    bloc.close();
  }

  @override
  void initState() {
    super.initState();

    bloc.add(FileConsulantsLoadEvent(id: widget.id));

    createChatBloc.stream.listen((state) {
      if (state is CreateChatLoading) {
        dismissDialog(errorDialogContext);
        loadingDialog(context: context);
      }

      if (state is CreateChatError) {
        dismissDialog(loadingDialogContext);
        errorDialog(context: context);
      }

      if (state is CreateChatSuccess) {
        dismissDialog(loadingDialogContext);
        notify("چت ایجاد شد");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, widget.isFavorite);

          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "مشاوران | ${widget.file.name}",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  doWithLogin(context, () async {
                    if (await addOrRemoveFavorite(widget.id)) {
                      setState(() {
                        widget.isFavorite = !widget.isFavorite;
                      });
                    }
                  });
                },
                icon: Icon(
                  widget.isFavorite ? Icons.bookmark : Icons.bookmark_border,
                ),
              ),
            ],
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context, widget.isFavorite);
              },
              icon: Icon(
                CupertinoIcons.back,
              ),
            ),
            elevation: 0.7,
          ),
          body: BlocBuilder<FileConsulantsBloc, FileConsulantsState>(
            builder: _buildMainBloc,
          ),
        ),
      ),
    );
  }

  Widget _buildMainBloc(context, FileConsulantsState state) {
    if (state is FileConsulantsInitState || state is FileConsulantsLoadingState) {
      return Center(
        child: Loading(),
      );
    }

    if (state is FileConsulantsErrorState) {
      String? message = jDecode(state.response?.body ?? "")['message'];

      return Center(
        child: TryAgain(
          onPressed: () {
            bloc.add(FileConsulantsLoadEvent(id: widget.id));
          },
          message: message,
        ),
      );
    }

    state = state as FileConsulantsLoadedState;

    return ListView(
      children: state.consultants.map<Widget>((e) => _item(e)).toList(),
    );
  }

  Widget _item(FileConsulant item) {
    return GestureDetector(
      onTap: () {
        push(
            context,
            AgentProfileScreen(
              consultantId: item.consultantId!.id!,
              name: item.consultantId!.name,
            ));
      },
      child: Container(
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
          color: App.theme.dialogBackgroundColor,
          border: Border(
            bottom: BorderSide(color: Themes.textGrey.withOpacity(0.2), width: 1),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    item.consultantId?.avatar ?? '',
                    height: 50,
                    width: 50,
                    errorBuilder: (_, _1, _2) => Image.asset(
                      "assets/images/profile.png",
                      height: 50,
                      width: 50,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.consultantId?.name ?? "؟؟؟",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "(${item.estateName.toString()})",
                        style: TextStyle(
                          color: App.theme.tooltipTheme.textStyle?.color,
                          fontSize: 10,
                        ),
                      ),
                      RatingBarIndicator(
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemSize: 14,
                        unratedColor: Colors.grey,
                        itemPadding: EdgeInsets.symmetric(horizontal: .2),
                        itemBuilder: (context, _) {
                          return Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 10,
                          );
                        },
                        rating: item.consultantId?.rate ?? 5.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    doWithLogin(context, () => createChat(item.id!));
                  },
                  child: Icon(
                    CupertinoIcons.chat_bubble_2,
                    size: 35,
                    color: Themes.primary,
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    callTo(item.consultantId!.phone!);
                  },
                  child: Icon(
                    CupertinoIcons.phone_circle,
                    size: 35,
                    color: Themes.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  createChat(int fileConsultantId) async {
    createChatBloc.add(CreateChatRequestEvent(fileConsultantId));
  }

  Future<bool> addOrRemoveFavorite(int id) async {
    if (widget.isFavorite) {
      return await removeFavorite(id);
    } else {
      return await addFavorite(id);
    }
  }

  Future<bool> addFavorite(int id) async {
    loadingDialog(context: context);

    var result = false;

    try {
      var response = await get(getFileUrl('file/addFileFavorite/' + id.toString() + '/'), headers: {
        "Authorization": await User.getBearerToken(),
      });

      if (isResponseOk(response)) {
        result = true;
      } else {
        var json = jDecode(response.body);
        notify(json['message'] ?? "خطا در ارسال اطلاعات رخ داد لطفا مجدد تلاش کنید");
        result = false;
      }
    } on HttpException {
      notify("خطا در ارسال اطلاعات رخ داد لطفا مجدد تلاش کنید");
    } catch (e) {
      notify("خطا در ارسال اطلاعات رخ داد لطفا مجدد تلاش کنید");
    }

    dismissDialog(loadingDialogContext);

    return result;
  }

  Future<bool> removeFavorite(int id) async {
    loadingDialog(context: context);

    var result = false;

    try {
      var response = await get(getFileUrl('file/deleteFileFavorite/' + id.toString() + '/'), headers: {
        "Authorization": await User.getBearerToken(),
      });

      if (isResponseOk(response)) {
        result = true;
      } else {
        var json = jDecode(response.body);
        notify(json['message'] ?? "خطا در ارسال اطلاعات رخ داد لطفا مجدد تلاش کنید");
        result = false;
      }
    } on HttpException {
      notify("خطا در ارسال اطلاعات رخ داد لطفا مجدد تلاش کنید");
    } on SocketException catch (e) {
      notify("خطا در ارسال اطلاعات رخ داد لطفا مجدد تلاش کنید");
    }

    dismissDialog(loadingDialogContext);

    return result;
  }
}
