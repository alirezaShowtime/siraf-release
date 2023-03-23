import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/ticket/get_groups_bloc.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/group.dart';
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

  @override
  void initState() {
    super.initState();

    getGroups();
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

  void createTicked() {
    if (selectedGroup == null || title == null) {
      notify("فیلدها خالی هستند");
      return;
    }

    
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
            onTap: createTicked,
          ),
        ],
      ),
    );
  }
}
