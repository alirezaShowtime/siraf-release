import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:siraf3/bloc/chat/create/create_chat_bloc.dart';
import 'package:siraf3/bloc/file_consulants_bloc.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/file_consulant.dart';
import 'package:siraf3/models/file_detail.dart' as file_detail;
import 'package:siraf3/models/user.dart';
import 'package:siraf3/screens/consultant_profile/consultant_profile_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/avatar.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_icon_button.dart';
import 'package:siraf3/widgets/static_star.dart';
import 'package:siraf3/widgets/try_again.dart';

import '../helpers.dart';
import 'chat/chat/chatScreen/chat_screen.dart';

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
        doWithLogin(
          context,
          () => push(
            context,
            ChatScreen(
              chatId: state.chatId,
              consultantId: state.fileConsultant.consultantId?.id,
              consultantImage: state.fileConsultant.consultantId?.avatar,
              consultantName: state.fileConsultant.consultantId?.name,
              fileId: state.file.id,
              fileTitle: state.file.name,
              fileImage: state.file.firstImage?.path,
              fileAddress: state.file.address,
            ),
          ),
        );
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

  Widget _item(FileConsultant item) {
    return GestureDetector(
      onTap: () {
        push(
            context,
            ConsultantProfileScreen(
              consultantId: item.consultantId!.id!,
              consultantName: item.consultantId!.name,
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
                Avatar(
                  imagePath: item.consultantId?.avatar ?? "",
                  errorImage: AssetImage("assets/images/profile.jpg"),
                  loadingImage: AssetImage("assets/images/profile.jpg"),
                  size: 50,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      StaticStar(rating: item.consultantId?.rate ?? 0)
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                MyIconButton(
                  onTap: () async {
                    doWithLogin(context, () => createChat(item, widget.file));
                  },
                  icon: Icon(
                    CupertinoIcons.chat_bubble_2,
                    size: 30,
                    color: Themes.primary,
                  ),
                ),
                SizedBox(width: 20),
                MyIconButton(
                  onTap: () {
                    callTo(item.consultantId!.phone!);
                  },
                  icon: Icon(
                    CupertinoIcons.phone_circle,
                    size: 30,
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

  createChat(FileConsultant consultant, file_detail.FileDetail file) async {
    createChatBloc.add(CreateChatRequestEvent(fileConsultant: consultant, file: file));
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
