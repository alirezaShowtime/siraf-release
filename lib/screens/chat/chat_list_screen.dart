import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/ticket/tickets_bloc.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/main.dart';
import 'package:siraf3/models/ticket.dart';
import 'package:siraf3/screens/ticket/chat/chat_screen.dart';
import 'package:siraf3/screens/ticket/ticket_creation_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_badge.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';
import 'package:siraf3/widgets/try_again.dart';

class ChatListScreen extends StatefulWidget {
  @override
  State<ChatListScreen> createState() => _ChatListScreen();
}

class _ChatListScreen extends State<ChatListScreen> {
  TicketsBloc ticketsBloc = TicketsBloc();

  @override
  void initState() {
    super.initState();

    ticketsBloc.add(TicketsEvent());
  }

  List<Ticket> tickets = [];
  List<Ticket> selectedTickets = [];
  bool isSelectable = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ticketsBloc,
      child: WillPopScope(
        onWillPop: () async {
          return _handleBack();
        },
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
            title: Row(
              children: [
                AppBarTitle("تیک های پشتیبانی"),
                MyBadge(text: "12"),
              ],
            ),
            actions: [
              if (selectedTickets.isNotEmpty)
                IconButton(
                  onPressed: () {
                    showDeleteDialog(selectedTickets.map((e) => e.id!).toList());
                  },
                  icon: Icon(
                    CupertinoIcons.delete,
                    color: null,
                  ),
                  disabledColor: Themes.iconGrey,
                ),
              MyPopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text(
                        "انتخاب همه",
                        style: TextStyle(
                          fontSize: 13,
                          color: App.theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      height: 35,
                    ),
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
          body: BlocBuilder<TicketsBloc, TicketsState>(builder: _listBlocBuilder),
          floatingActionButton: FloatingActionButton(
            onPressed: createTicket,
            backgroundColor: Themes.primary,
            shape: CircleBorder(),
            tooltip: "ایجاد تیکت",
            child: icon(Icons.add_rounded, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget item(Ticket ticket) {
    return GestureDetector(
      onTap: () {
        if (isSelectable) {
          _changeSelection(ticket);
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen()));
        }
      },
      onLongPress: () {
        _changeSelection(ticket);
      },
      child: Container(
        height: 65,
        color: App.theme.dialogBackgroundColor,
        foregroundDecoration: BoxDecoration(
          color: selectedTickets.any((e) => e.id == ticket.id) ? Themes.blue.withOpacity(0.2) : Colors.transparent,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(100),
                //   child: Image(
                //     image: NetworkImage(
                //         "https://www.seiu1000.org/sites/main/files/imagecache/hero/main-images/camera_lense_0.jpeg"),
                //     width: 50,
                //     height: 50,
                //     fit: BoxFit.fill,
                //     alignment: Alignment.center,
                //     loadingBuilder: (context, child, loadingProgress) {
                //       if (loadingProgress == null) return child;
                //       return Image.asset(
                //         "assets/images/profile.png",
                //         width: 50,
                //         height: 50,
                //         fit: BoxFit.fill,
                //         alignment: Alignment.center,
                //       );
                //     },
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 3, right: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            ticket.groupName ?? "",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            " | ",
                            style: TextStyle(
                              color: App.theme.tooltipTheme.textStyle?.color,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            ticket.title ?? "",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: App.theme.tooltipTheme.textStyle?.color,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        ticket.lastMessage?.trim() ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: App.theme.tooltipTheme.textStyle?.color,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyBadge(text: "23"), // todo change dynamically
                Text(
                  "12:54", // todo change dynamically
                  style: TextStyle(
                    color: App.theme.tooltipTheme.textStyle?.color,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void createTicket() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => TicketCreationScreen()));
  }

  Widget _listBlocBuilder(BuildContext context, TicketsState state) {
    if (state is TicketsInitState) return Container();

    if (state is TicketsLoadingState)
      return Center(
        child: Loading(),
      );

    if (state is TicketsErrorState) {
      return Center(
        child: TryAgain(
          onPressed: (() {
            ticketsBloc.add(TicketsEvent());
          }),
        ),
      );
    }

    state = TicketsLoadedState(tickets: (state as TicketsLoadedState).tickets);

    tickets = state.tickets;

    if (tickets.isEmpty) {
      return Center(
        child: Text(
          "گفتگویی وجود ندارد یک تیکت ایجاد کنید",
          style: TextStyle(fontSize: 13),
        ),
      );
    }

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
          backgroundColor: App.theme.dialogBackgroundColor,
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
                          color: App.theme.tooltipTheme.textStyle?.color,
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

  _changeSelection(Ticket ticket) {
    setState(() {
      if (selectedTickets.any((e) => e.id == ticket.id)) {
        selectedTickets.remove(ticket);
      } else {
        selectedTickets.add(ticket);
      }

      isSelectable = selectedTickets.isNotEmpty;
    });
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
