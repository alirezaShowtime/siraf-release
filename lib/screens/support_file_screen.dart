import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:siraf3/bloc/file_consulants_bloc.dart';
import 'package:siraf3/models/file_consulant.dart';
import 'package:siraf3/models/file_detail.dart' as file_detail;
import 'package:siraf3/models/user.dart';
import 'package:siraf3/screens/auth/login_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/try_again.dart';

import '../helpers.dart';

class SupportFileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SupportFileScreen();

  SupportFileScreen({required this.file});

  file_detail.FileDetail file;
}

class _SupportFileScreen extends State<SupportFileScreen> {
  FileConsulantsBloc bloc = FileConsulantsBloc();

  @override
  void initState() {
    super.initState();

    bloc.add(FileConsulantsLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Themes.background,
          title: Text(
            "مشاوران | ${widget.file.name}",
            style: TextStyle(
              fontSize: 12,
              color: Themes.text,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.bookmark_border,
                color: Themes.icon,
              ),
            ),
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              CupertinoIcons.back,
              color: Themes.icon,
            ),
          ),
          elevation: 0.7,
        ),
        body: BlocBuilder<FileConsulantsBloc, FileConsulantsState>(
            builder: _buildMainBloc),
      ),
    );
  }

  Widget _buildMainBloc(context, FileConsulantsState state) {
    if (state is FileConsulantsInitState ||
        state is FileConsulantsLoadingState) {
      return Center(
        child: Loading(),
      );
    }

    if (state is FileConsulantsErrorState) {
      String? message = jDecode(state.response?.body ?? "")['message'];

      return Center(
        child: TryAgain(
          onPressed: () {
            bloc.add(FileConsulantsLoadEvent());
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
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
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
                        color: Themes.text,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "(املاک خرم)",
                      style: TextStyle(
                        color: Themes.textGrey,
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
                      rating: 4.2,
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
                  doWithLogin(context, () {
                    createChat();
                  });
                },
                child: Image.asset(
                  icon('chat'),
                  height: 40,
                  width: 40,
                  color: Themes.primary,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {
                  callTo(item.consultantId!.phone!);
                },
                child: Image.asset(
                  icon('call'),
                  height: 33,
                  width: 33,
                  color: Themes.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  showLoadingDialog({String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        loadingDContext = _;
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          content: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 170,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    message ?? 'در حال ارسال درخواست صبور باشید',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Loading(),
              ],
            ),
          ),
        );
      },
    );
  }

  dissmisLoadingDialog() {
    if (loadingDContext != null) {
      Navigator.pop(loadingDContext!);
    }
  }

  BuildContext? loadingDContext;

  createChat() async {
    showLoadingDialog(message: "درحال ایجاد گفتگو هستیم شکیبا باشید");

    //todo: implement

    await Future.delayed(Duration(seconds: 2));

    dissmisLoadingDialog();
  }
}
