import 'package:flutter/material.dart';

import '../theme/theme.dart';

class StackCardWidget extends StatelessWidget {
  const StackCardWidget(
      {super.key, required this.balance, this.maskedCardNumber});

  final String balance;
  final String? maskedCardNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xff6C54FF), Color(0xffE93A3A)],
            begin: Alignment.centerLeft),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(children: [
        Positioned(
          top: 20,
          left: 20,
          child: Text(
            'Current Balance',
            style: poppinsMedium14.copyWith(color: Colors.white),
          ),
        ),
        Positioned(
          top: 40,
          left: 20,
          child: Text(
            '\u{20B9} $balance',
            style: poppinsSemiBold18.copyWith(
                fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: Text(
            maskedCardNumber ?? '',
            style: poppinsMedium14.copyWith(color: Colors.white),
          ),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: Image.asset('assets/images/once_load_rupay.png'),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: Image.asset('assets/images/rupay1.png'),
        ),
      ]),
    );
  }
}
