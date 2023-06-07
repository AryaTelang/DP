import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SharedAppBar extends StatelessWidget with PreferredSizeWidget {
  SharedAppBar({super.key, this.actions, required this.appBar, this.title});

  List<Widget>? actions;
  AppBar appBar;
  Widget? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => appBar.preferredSize;
}
