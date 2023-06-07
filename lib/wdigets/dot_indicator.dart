import 'package:bachat_cards/theme/theme.dart';
import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  const DotIndicator({super.key, this.isActive = false});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: isActive ? 40 : 10,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: isActive ? primaryColor : const Color(0xff9182F3)),
    );
  }
}
