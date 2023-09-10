import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/ticket/create_ticket_bloc.dart';
import 'package:siraf3/bloc/ticket/get_groups_bloc.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/group.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/block_btn.dart';
import 'package:siraf3/widgets/list_dialog.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/simple_app_bar.dart';
import 'package:siraf3/widgets/text_form_field_2.dart';
import 'package:siraf3/widgets/try_again.dart';
import 'package:siraf3/main.dart';

class TicketCreationScreen extends StatefulWidget {
  GroupModel? group;

  TicketCreationScreen({this.group, Key? key}) : super(key: key);

  @override
  State<TicketCreationScreen> createState() => _TicketCreationScreen();
}

class _TicketCreationScreen extends State<TicketCreationScreen> {
  GroupModel? selectedGroup;
  String? title;
  String? message;
  List<GroupModel> groups = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  GetGroupsBloc getGroupsBloc = GetGroupsBloc();
  CreateTicketBloc createTicketBloc = CreateTicketBloc();

  @override
  void initState() {
    super.initState();

    getGroups();
    setSelectedGroup();
    createTicketBloc.stream.listen(_listenCreateState);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getGroupsBloc,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: SimpleAppBar(titleText: "پشتیبانی آنلاین"),
        body: BlocBuilder<GetGroupsBloc, GetGroupsState>(builder: _buildMainContent),
      ),
    );
  }

  void createTicket() {
    title = titleController.text.trim().isNotNullOrEmpty() ? titleController.text.trim() : null;
    message = messageController.text.trim().isNotNullOrEmpty() ? messageController.text.trim() : null;
    if (selectedGroup == null || title == null || message == null) {
      notify("لطفا موارد فوق را تکمیل نمایید");
      return;
    }

    if (title!.length < 5) {
      notify("عنوان باید حداقل پنج کاراکتر باشد");
      return;
    }

    createTicketBloc.add(CreateTicketEvent(title: title!, message: message!, group: selectedGroup!));
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
              selectedGroup = groups.firstWhere((element) => element.id == item["value"]);
            });
            Navigator.pop(context);
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
          message: state.response.statusCode < 500 ? jDecode(state.response.body)['message'] : null,
        ),
      );
    }

    state = GetGroupsLoadedState(groups: (state as GetGroupsLoadedState).groups);

    groups = state.groups;

    return Padding(
      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: determineSupportSection,
            child: Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Themes.icon,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "بخش پشتیبانی",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "IranSansMedium",
                      color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(minWidth: 30),
                    color: Colors.transparent,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      selectedGroup?.name ?? "انتخاب",
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: "IranSansMedium",
                        color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            "موضوع",
            style: TextStyle(
              fontSize: 13,
              color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
              fontFamily: "IranSansMedium",
            ),
          ),
          SizedBox(height: 3),
          TextFormField2(
            decoration: InputDecoration(
              hintText: "چه موضوعی را میخواهید مطرح کنید",
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Themes.icon,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: App.theme.primaryColor,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              hintStyle: TextStyle(fontSize: 13),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
            style: TextStyle(fontSize: 13, color: App.theme.textTheme.bodyLarge?.color ?? Themes.text),
            cursorColor: App.theme.primaryColor,
            maxLines: 1,
            minLines: 1,
            controller: titleController,
          ),
          SizedBox(height: 10),
          Text(
            "پیام",
            style: TextStyle(
              fontSize: 13,
              color: App.theme.textTheme.bodyLarge?.color ?? Themes.text,
              fontFamily: "IranSansMedium",
            ),
          ),
          SizedBox(height: 3),
          TextFormField2(
            decoration: InputDecoration(
              hintText: "پیام خود را بنویسید",
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Themes.icon,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: App.theme.primaryColor,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: App.theme.textTheme.bodyLarge?.color ?? Themes.textGrey,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              hintStyle: TextStyle(fontSize: 13),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
            style: TextStyle(fontSize: 13, color: App.theme.textTheme.bodyLarge?.color ?? Themes.text),
            cursorColor: App.theme.primaryColor,
            maxLines: 50,
            minLines: 6,
            controller: messageController,
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

  _listenCreateState(CreateTicketState state) {
    if (state is CreateTicketLoadingState) {
      loadingDialog(context: context);
    }
    if (state is CreateTicketErrorState) {
      dismissDialog(loadingDialogContext);

      errorDialog(context: context, message: state.message);
    }
    if (state is CreateTicketSuccessState) {
      dismissDialog(loadingDialogContext);
      notify("گفتگو با موفقیت ایجاد شد");
      Navigator.pop(context, true);
    }
  }

  setSelectedGroup() {
    setState(() {
      selectedGroup = widget.group;
    });
  }
}
