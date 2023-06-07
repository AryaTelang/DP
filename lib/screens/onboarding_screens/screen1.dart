import 'package:bachat_cards/screens/auth_screens/is_new_user_screen.dart';
import 'package:bachat_cards/screens/onboarding_screens/screen2.dart';
import 'package:bachat_cards/sevrices/shared_prefs.dart';
import 'package:bachat_cards/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xff7443FF),
                Color(0xff391E85),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
          ),
          Positioned(
            right: 0,
            top: MediaQuery.of(context).padding.top,
            child: TextButton(
              onPressed: () {
                SharedPrefs.setIsFirstInstalled();
                Get.to(() => const IsNewUserScreen());
              },
              child: Text(
                'SKIP',
                style: latoRegular16.copyWith(color: Colors.white),
              ),
            ),
          ),
          Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Image.asset(
                'assets/images/logo.png',
                width: MediaQuery.of(context).size.width / 1.5,
                height: MediaQuery.of(context).size.height / 4,
                fit: BoxFit.contain,
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                'WELCOME',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 50),
              )
            ]),
          )
        ],
      ),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: const Text(
          'NEXT',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
              fontSize: 16,color: textColor),
        ),
        onPressed: () => Get.to(() => OnboardingScreen2()),
      ),
    );
  }
}
