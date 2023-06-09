import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/ticket/list/ticket_list_bloc.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/ticket.dart';
import 'package:siraf3/screens/ticket/ticket_chat/ticket_chat_screen.dart';
import 'package:siraf3/screens/ticket/ticket_creation_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/avatar.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_icon_button.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';
import 'package:siraf3/widgets/my_popup_menu_item.dart';
import 'package:siraf3/widgets/try_again.dart';

class TicketListScreen extends StatefulWidget {
  @override
  State<TicketListScreen> createState() => _TicketListScreen();
}

class _TicketListScreen extends State<TicketListScreen> {
  TicketListBloc ticketsBloc = TicketListBloc();

  @override
  void initState() {
    super.initState();

    ticketsBloc.add(TicketListRequestEvent());
  }

  List<Ticket> tickets = [];
  List<Ticket> selectedTickets = [];
  bool isSelectable = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ticketsBloc,
      child: WillPopScope(
        onWillPop: () async => _handleBack(),
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.7,
            titleSpacing: 0,
            leading: MyBackButton(
              onPressed: () {
                if (_handleBack()) {
                  Navigator.pop(context);
                }
              },
            ),
            title: AppBarTitle("تیک های پشتیبانی"),
            actions: [
              if (selectedTickets.isNotEmpty)
                MyIconButton(
                  onTap: () {
                    showDeleteDialog(selectedTickets.map((e) => e.id!).toList());
                  },
                  iconData: CupertinoIcons.delete,
                ),
              MyIconButton(
                onTap: () {
                  push(context, TicketCreationScreen());
                },
                iconData: Icons.add_rounded,
              ),
              MyPopupMenuButton(
                itemBuilder: (context) {
                  return [
                    MyPopupMenuItem<int>(value: 0, label: "انتخاب همه", icon: Icons.check_circle_outline_rounded),
                  ];
                },
                onSelected: (value) {
                  setState(() {
                    selectedTickets.clear();
                    selectedTickets.addAll(tickets);
                    isSelectable = true;
                  });
                },
                iconData: Icons.more_vert,
              ),
            ],
          ),
          body: BlocBuilder<TicketListBloc, TicketListState>(builder: _listBlocBuilder),
        ),
      ),
    );
  }

  Widget item(Ticket ticket) {
    return Material(
      color: !ticket.status! ? Colors.white : Colors.grey.shade100,
      child: InkWell(
        onTap: () {
          if (!ticket.status!) return;

          push(context, TicketChatScreen(ticket: ticket));
        },
        child: Container(
          height: 65,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.black12, width: 0.5),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Avatar(
                  imagePath: ticket.ticketSender?.avatar ?? "",
                  size: 50,
                  errorImage: AssetImage("assets/images/profile.jpg"),
                  loadingImage: AssetImage("assets/images/profile.jpg"),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${ticket.groupName ?? "ناشناس"} | ",
                          style: TextStyle(
                            fontSize: 12,
                            color: Themes.text,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            ticket.title ?? "بدون موضوع",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: Themes.textGrey,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      ticket.lastMessage?.trim() ?? "",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade400,
                        height: 2,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${ticket.lastMessageCreateTime} ${ticket.lastMessageCreateDate}",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 9),
                  ),
                  SizedBox(height: 10),
                  Text(
                    ticket.statusMessage!,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listBlocBuilder(BuildContext context, TicketListState state) {
    if (state is TicketListInitial) return Container();

    if (state is TicketListLoading) return Center(child: Loading());

    if (state is TicketListError) {
      return Center(
        child: TryAgain(
          message: state.message,
          onPressed: (() {
            ticketsBloc.add(TicketListRequestEvent());
          }),
        ),
      );
    }

    tickets = (state as TicketListSuccess).tickets;

    return ListView(
      children: tickets.map<Widget>((e) => item(e)).toList(),
    );
  }

  BuildContext? deleteDialogContext;

  showDeleteDialog(List<int> ids) {
    showDialog2(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        deleteDialogContext = _;
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: Themes.themeData().dialogBackgroundColor,
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Wrap(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: Text(
                        'آیا مایل به حذف فایل هستید؟',
                        style: TextStyle(
                          color: Themes.themeData().tooltipTheme.textStyle?.color,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Themes.primary,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                      ),
                      height: 40,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: dismissDeleteDialog,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(5),
                                ),
                              ),
                              color: Themes.primary,
                              elevation: 1,
                              height: 40,
                              child: Text(
                                "خیر",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: "IranSansBold",
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 9),
                            ),
                          ),
                          Expanded(
                            child: MaterialButton(
                              onPressed: () async {
                                // todo delete tickets
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                ),
                              ),
                              color: Themes.primary,
                              elevation: 1,
                              height: 40,
                              child: Text(
                                "بله",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: "IranSansBold",
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  dismissDeleteDialog() {
    if (deleteDialogContext != null) {
      Navigator.pop(deleteDialogContext!);
    }
  }

  _handleBack() {
    if (isSelectable) {
      setState(() {
        isSelectable = false;
        selectedTickets.clear();
      });
      return false;
    }
    return true;
  }
}
