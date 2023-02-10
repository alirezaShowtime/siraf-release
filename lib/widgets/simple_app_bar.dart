import 'package:flutter/material.dart';
import 'package:siraf3/widgets/app_bar_title.dart';
import 'package:siraf3/widgets/my_back_button.dart';

import '../themes.dart';

class SimpleAppBar extends AppBar {
  @override
  State<AppBar> createState() => _SimpleAppBar();

  String titleText;

  SimpleAppBar({required this.titleText});
}

class _SimpleAppBar extends State<SimpleAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Themes.appBar,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      elevation: 0.7,
      title: AppBarTitle(widget.titleText),
      leading: MyBackButton(),
    );
  }
}
