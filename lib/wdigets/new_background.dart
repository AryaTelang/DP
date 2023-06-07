import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key, required this.childWidget});

  final Widget childWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFF7C64FF), Color(0xFF130078)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),

      child: Padding(
        padding: EdgeInsets.only(top: 250),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(55), topRight: Radius.circular(55)),
          ),
          child: childWidget,
        ),
      ),
    );
  }
}
