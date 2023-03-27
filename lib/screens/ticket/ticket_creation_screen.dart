import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/ticket/create_ticket_bloc.dart';
import 'package:siraf3/bloc/ticket/get_groups_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/group.dart';
import 'package:siraf3/screens/home_screen.dart';
import 'package:siraf3/screens/ticket/ticket_list_screen.dart';
import 'package:siraf3/widgets/block_btn.dart';
import 'package:siraf3/widgets/field_dialog.dart';
import 'package:siraf3/widgets/list_dialog.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/section.dart';
import 'package:siraf3/widgets/simple_app_bar.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/widgets/try_again.dart';

class TicketCreationScreen extends StatefulWidget {
  @override
  State<TicketCreationScreen> createState() => _TicketCreationScreen();
}

class _TicketCreationScreen extends State<TicketCreationScreen> {
  Group? selectedGroup;
  String? title;
  List<Group> groups = [];

  TextEditingController titleController = TextEditingController();

  GetGroupsBloc getGroupsBloc = GetGroupsBloc();
  CreateTicketBloc createTicketBloc = CreateTicketBloc();

  @override
  void initState() {
    super.initState();

    getGroups();
    createTicketBloc.stream.listen(_listenCreateState);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getGroupsBloc,
      child: Scaffold(
        appBar: SimpleAppBar(titleText: "پشتیبانی آنلاین"),
        body: BlocBuilder<GetGroupsBloc, GetGroupsState>(
            builder: _buildMainContent),
      ),
    );
  }

  void createTicket() {
    if (selectedGroup == null || title == null) {
      notify("لطفا موارد فوق را تکمیل نمایید");
      return;
    }

    if (title!.length < 5) {
      notify("عنوان باید حداقل پنج کاراکتر باشد");
      return;
    }

    createTicketBloc
        .add(CreateTicketEvent(title: title!, group: selectedGroup!));
  }

  void determineSupportSection() {
    showDialog2(
      context: context,
      builder: (context) {
        return ListDialog(
          list: groups
              .map<Map<String, dynamic>>((e) => {
                    "name": e.name,
                    "value": e.id,
                  })
              .toList(),
          onItemTap: (item) {
            setState(() {
              selectedGroup =
                  groups.firstWhere((element) => element.id == item["value"]);
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void determineTitle() {
    showDialog2(
      context: context,
      builder: (context) {
        return FieldDialog(
          numberFieldController: titleController,
          hintText: "عنوان را وارد کنید",
          onPressed: () {
            title = titleController.value.text;
            setState(() {});
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();

    getGroupsBloc.close();
    createTicketBloc.close();
  }

  getGroups() {
    getGroupsBloc.add(GetGroupsEvent());
  }

  Widget _buildMainContent(BuildContext context, GetGroupsState state) {
    if (state is GetGroupsInitState) {
      return Container();
    }

    if (state is GetGroupsLoadingState) {
      return Center(
        child: Loading(),
      );
    }

    if (state is GetGroupsErrorState) {
      return Center(
        child: TryAgain(
          onPressed: getGroups,
          message: state.response.statusCode < 500
              ? jDecode(state.response.body)['message']
              : null,
        ),
      );
    }

    state =
        GetGroupsLoadedState(groups: (state as GetGroupsLoadedState).groups);

    groups = state.groups;

    return Padding(
      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        children: [
          Section(
            title: "بخش پشتیبانی",
            hint: "انتخاب",
            value: selectedGroup?.name,
            onTap: determineSupportSection,
          ),
          Section(
            title: "عنوان",
            hint: "تعیین",
            value: title,
            onTap: determineTitle,
          ),
          BlockBtn(
            text: "شروع گفتگو",
            padding: EdgeInsets.only(top: 15),
            onTap: createTicket,
          ),
        ],
      ),
    );
  }

  _listenCreateState(CreateTicketState event) {
    if (event is CreateTicketLoadingState) {
      showLoadingDialog();
    } else if (event is CreateTicketErrorState) {
      String message = "";

      dismissLoadingDialog();
      if (event.response?.data != null) {
        try {
          message = event.response!.data!['message'];
        } on Exception catch (e) {
          message = "خطایی در ایجاد گفتگو پیش آمد لطفا بعدا مجدد تلاش کنید";
        }
      } else {
        message = "خطایی در ایجاد گفتگو پیش آمد لطفا بعدا مجدد تلاش کنید";
      }

      showErrorDialog(message);
    } else if (event is CreateTicketSuccessState) {
      dismissLoadingDialog();
      notify("گفتگو با موفقیت ایجاد شد");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => TicketListScreen()),
      );
    }
  }

  showLoadingDialog() {
    showDialog2(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        loadingDContext = _;
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          content: Container(
            decoration: BoxDecoration(
              color: App.theme.dialogBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 170,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    'در حال ایجاد گفتگو لطفا شکیبا باشید',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: App.theme.textTheme.bodyLarge?.color,
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

  dismissLoadingDialog() {
    if (loadingDContext != null) {
      Navigator.pop(loadingDContext!);
    }
  }

  BuildContext? loadingDContext;

  showErrorDialog(String s) {
    showDialog2(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          content: Container(
            decoration: BoxDecoration(
              color: App.theme.dialogBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 170,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    'خطا',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    s,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: App.theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
