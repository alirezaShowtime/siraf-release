import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siraf3/bloc/ticket/close/close_ticket_bloc.dart';
import 'package:siraf3/bloc/ticket/list/ticket_list_bloc.dart';
import 'package:siraf3/dialog.dart';
import 'package:siraf3/helpers.dart';
import 'package:siraf3/models/ticket.dart';
import 'package:siraf3/screens/ticket/ticket_chat/ticket_chat_screen.dart';
import 'package:siraf3/screens/ticket/ticket_creation_screen.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/avatar.dart';
import 'package:siraf3/widgets/confirm_dialog.dart';
import 'package:siraf3/widgets/loading.dart';
import 'package:siraf3/widgets/my_back_button.dart';
import 'package:siraf3/widgets/my_popup_menu_button.dart';
import 'package:siraf3/widgets/my_popup_menu_item.dart';
import 'package:siraf3/widgets/try_again.dart';
import 'package:badges/badges.dart' as badges;

class TicketListScreen extends StatefulWidget {
  @override
  State<TicketListScreen> createState() => _TicketListScreen();
}

class _TicketListScreen extends State<TicketListScreen> {
  TicketListBloc ticketsBloc = TicketListBloc();
  CloseTicketBloc closeTicketBloc = CloseTicketBloc();

  @override
  void initState() {
    super.initState();

    ticketsBloc.add(TicketListRequestEvent());

    ticketsBloc.stream.listen((event) {
      if (event is TicketListSuccess) {
        setState(() {
          event.tickets.forEach((element) {
            totalNoSeen += element.messageNotSeen ?? 0;
          });
        });
      }
    });

    closeTicketBloc.stream.listen((state) {
      if (state is CloseTicketLoading) {
        dismissDialog(errorDialogContext);
        loadingDialog(context: context);
        return;
      }

      if (state is CloseTicketError) {
        dismissDialog(loadingDialogContext);
        errorDialog(context: context, message: state.message);
        return;
      }

      if (state is CloseTicketSuccess) {
        dismissDialog(loadingDialogContext);
        notify("تیکت های انتخاب شده بسته شدند");
        setState(() {
          tickets = sortTickets(tickets.map((e) {
            if (selectedTickets.contains(e)) {
              e.status = false;
            }
            return e;
          }).toList());
        });
        selectedTickets.clear();
        isSelectable = false;
      }
    });
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
            title: Row(
              children: [
                AppBarTitle("تیک های پشتیبانی"),
                if (totalNoSeen > 0)
                  badges.Badge(
                    showBadge: true,
                    badgeContent: Text(
                      "${totalNoSeen}",
                      style: TextStyle(color: Colors.white),
                    ),
                    badgeStyle: badges.BadgeStyle(
                        badgeColor: Themes.primary,
                        padding: EdgeInsets.symmetric(horizontal: 12)),
                  ),
              ],
            ),
            actions: [
              if (selectedTickets.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 13),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      showDeleteDialog(
                          selectedTickets.map((e) => e.id!).toList());
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.close_rounded,
                            size: 20,
                            color: Colors.red,
                          ),
                          Text(
                            "بستن تیکت",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 10,
                              fontFamily: "IranSansBold",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              MyPopupMenuButton(
                itemBuilder: (context) {
                  return [
                    MyPopupMenuItem<int>(
                        enable: selectedTickets.length < tickets.length,
                        value: 0,
                        label: "انتخاب همه"),
                    if (selectedTickets.isNotEmpty)
                      MyPopupMenuItem<int>(value: 1, label: "لغو انتخاب همه"),
                  ];
                },
                onSelected: (value) {
                  if (value == 0) {
                    setState(() {
                      selectedTickets.clear();
                      selectedTickets.addAll(tickets);
                      isSelectable = true;
                    });
                  }
                  if (value == 1) {
                    setState(() {
                      selectedTickets.clear();
                      isSelectable = false;
                    });
                  }
                },
                iconData: Icons.more_vert,
              ),
            ],
          ),
          body: BlocBuilder<TicketListBloc, TicketListState>(
              builder: _listBlocBuilder),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              push(context, TicketCreationScreen());
            },
            backgroundColor: Themes.primary,
            child: Icon(Icons.add_rounded, color: Colors.white),
          ),
        ),
      ),
    );
  }

  int totalNoSeen = 0;

  Widget item(Ticket ticket) {
    bool isSelected = selectedTickets.contains(ticket);

    return Material(
      color: ticket.status ? Colors.white : Colors.grey.shade100,
      child: InkWell(
        onLongPress: () {
          if (!isSelected) {
            setState(() {
              selectedTickets.add(ticket);
              isSelectable = true;
            });
            return;
          }
        },
        onTap: () {
          if (!isSelected && isSelectable) {
            setState(() {
              selectedTickets.add(ticket);
            });
            return;
          }
          if (isSelected) {
            setState(() {
              selectedTickets.remove(ticket);
            });
            return;
          }

          if (!ticket.status) {
            notify("این تیکت بسته شده است");
            return;
          }
          push(context, TicketChatScreen(ticket: ticket));

          setState(() {
            totalNoSeen -= ticket.messageNotSeen ?? 0;
            ticket.messageNotSeen = 0;
          });
        },
        child: Container(
          height: 65,
          foregroundDecoration: !isSelected
              ? null
              : BoxDecoration(color: Themes.primary.withOpacity(0.1)),
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
                  image: AssetImage("assets/images/profile.jpg"),
                  size: 50,
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
                            fontFamily: "IranSansBold",
                          ),
                        ),
                        Expanded(
                          child: Text(
                            ticket.title ?? "بدون موضوع",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: Themes.textGrey,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    ticket.timeAgo ??
                        "${ticket.lastMessageCreateTime} ${ticket.lastMessageCreateDate}",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 9),
                  ),
                  Row(
                    children: [
                      Text(
                        !ticket.status
                            ? "بسته شده"
                            : (ticket.statusMessage ?? ""),
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 9,
                            fontFamily: "IRANSansBold"),
                      ),
                      if ((ticket.messageNotSeen ?? 0) > 0)
                        SizedBox(
                          width: 7,
                        ),
                      if ((ticket.messageNotSeen ?? 0) > 0)
                        badges.Badge(
                          showBadge: true,
                          badgeContent: Text(
                            "${ticket.messageNotSeen}",
                            style: TextStyle(color: Colors.white),
                          ),
                          badgeStyle: badges.BadgeStyle(
                              badgeColor: Themes.primary,
                              padding: EdgeInsets.symmetric(horizontal: 12)),
                        ),
                    ],
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

    tickets = sortTickets(tickets);

    return ListView(
      children: tickets.map<Widget>((e) => item(e)).toList(),
    );
  }

  BuildContext? deleteDialogContext;

  showDeleteDialog(List<int> ids) {
    animationDialog(
        context: context,
        builder: (dialogContext) {
          return ConfirmDialog(
            dialogContext: dialogContext,
            content:
                "آیا واقعا قصد بستن ${selectedTickets.length} تیکت را دارید؟",
            onApply: () {
              closeTicketBloc.add(CloseTicketRequestEvent(
                  selectedTickets.map((e) => e.id!).toList()));
              dismissDialog(dialogContext);
            },
          );
        });
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

  List<Ticket> sortTickets(List<Ticket> tickets) {
    List<Ticket> list = [];
    List<Ticket> disabled = [];
    List<Ticket> pending = [];

    for (Ticket ticket in tickets) {
      if (!ticket.status) {
        disabled.add(ticket);
        continue;
      }
      if (ticket.statusMessage == "پاسخ کاربر") {
        list.add(ticket);
        continue;
      }
      if (ticket.statusMessage == "در انتظار پاسخ") {
        pending.add(ticket);
        continue;
      }
    }

    list.addAll(pending);
    list.addAll(disabled);
    return list;
  }
}
