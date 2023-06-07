import 'dart:io';

import 'package:bachat_cards/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class FailScreen extends StatelessWidget {
  const FailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Platform.isIOS ? AppBar() : null,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
              'Uh oh....',
              style: poppinsBold20.copyWith(fontSize: 24),
            ),
            RichText(
              text: TextSpan(
                text: 'Your payment was ',
                style: poppinsBold20.copyWith(color: Colors.black),
                children: [
                  TextSpan(
                      text: 'Fail !',
                      style: poppinsBold20.copyWith(color: Colors.red[500]))
                ],
              ),
            ),
            _spacer16(),
            _spacer16(),
            SvgPicture.asset('assets/images/fail.svg'),
            _spacer16(),
            _spacer16(),
            Text(
              'Please Try Payment again',
              style: poppinsSemiBold18.copyWith(fontSize: 16),
            ),
            _spacer16(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Your payment was unsuccessful please click on the button below to retry.',
                style: latoBold16.copyWith(color: grey, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
              child: const Text(
                'Retry Payment',
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ]),
        ),
      ),
    );
  }

  _spacer16() {
    return const SizedBox(
      height: 16,
    );
  }
}
