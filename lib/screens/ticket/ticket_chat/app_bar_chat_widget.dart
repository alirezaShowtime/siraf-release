import 'package:flutter/material.dart';
import 'package:siraf3/config.dart';
import 'package:siraf3/models/ticket.dart';
import 'package:siraf3/themes.dart';
import 'package:siraf3/widgets/avatar.dart';
import 'package:siraf3/widgets/my_back_button.dart';

class AppBarChat extends AppBar {
  @override
  State<AppBar> createState() => _AppBarChat();

  Ticket ticket;

  AppBarChat({required this.ticket});
}

class _AppBarChat extends State<AppBarChat> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: defaultElevation,
      titleSpacing: 0,
      leading: MyBackButton(),
      title: title(),
    );
  }

  Widget title() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Avatar(
            imagePath: widget.ticket.ticketSender?.avatar ?? "",
            size: 40,
            errorImage: AssetImage("assets/images/profile.jpg"),
            loadingImage: AssetImage("assets/images/profile.jpg"),
          ),
        ),
        Expanded(
          child: Text(
            widget.ticket.groupName ?? "پشتیبانی",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Themes.themeData().textTheme.bodyLarge?.color,
            ),
          ),
        ),
      ],
    );
  }
}
