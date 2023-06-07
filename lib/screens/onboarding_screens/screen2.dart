import 'package:bachat_cards/controllers/onboarding_screen_controller.dart';
import 'package:bachat_cards/screens/auth_screens/is_new_user_screen.dart';
import 'package:bachat_cards/sevrices/shared_prefs.dart';
import 'package:bachat_cards/theme/theme.dart';
import 'package:bachat_cards/wdigets/dot_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class OnboardingScreen2 extends StatelessWidget {
  OnboardingScreen2({super.key});

  final _pageViewController = PageController();
  final onboardingScreenController = Get.put(OnboardingScreenController());

  @override
  Widget build(BuildContext context) {
    List<Widget> onboardingWidgets = [
      Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/images/onboarding_screen_background.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
              ),
              Image.asset(
                'assets/images/onboarding_image.png',
              ),
              const SizedBox(
                height: 72,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Get 1 % instant cashback on every  purchase.',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: textColor),
                ),
              ),
            ],
          )
        ],
      ),
      Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/images/onboarding_screen_background_2.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
              ),
              Image.asset(
                'assets/images/onboarding_image_2.png',
                width: MediaQuery.of(context).size.width / 1.5,
                height: MediaQuery.of(context).size.height / 4,
                fit: BoxFit.contain,
              ),
              const SizedBox(
                height: 72,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Redeem cashback points on 650+ Gift cards.',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: textColor),
                ),
              ),
            ],
          )
        ],
      ),
      Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/images/onboarding_screen_background_2.png',
              fit: BoxFit.cover,
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
                height: 32,
              ),
              const Text(
                'OUR PARTNERS',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: secondaryColor,
                ),
              ),
            ]),
          ),
          Positioned(
            bottom: 140,
            left: MediaQuery.of(context).size.width * 0.08,
            child: Image.asset('assets/images/pinelabs.png'),
          ),
          Positioned(
            bottom: 140,
            right: MediaQuery.of(context).size.width * 0.08,
            child: Image.asset('assets/images/startupindia.png'),
          ),
          Positioned(
            bottom: 70,
            right: MediaQuery.of(context).size.width * 0.1,
            child: Image.asset('assets/images/rupay.png'),
          ),
          Positioned(
            bottom: 70,
            left: MediaQuery.of(context).size.width * 0.08,
            child: Image.asset('assets/images/npci.png'),
          ),
        ],
      ),
    ];
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              PageView(
                  onPageChanged: (value) {
                    onboardingScreenController.index.value = value;
                  },
                  controller: _pageViewController,
                  children: onboardingWidgets),
              Positioned(
                bottom: 40,
                left: 20,
                child: Wrap(
                  spacing: 4,
                  children: List.generate(
                      onboardingWidgets.length,
                      (index) => Obx(() => DotIndicator(
                          isActive: onboardingScreenController.index.value ==
                              index))),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    'NEXT',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
                  onPressed: () {
                    if (onboardingScreenController.index.value <
                        onboardingWidgets.length - 1) {
                      _pageViewController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
                    } else {
                      SharedPrefs.setIsFirstInstalled();
                      Get.to(() => const IsNewUserScreen());
                    }
                  },
                ),
              )
            ],
          ),
        ));
  }
}
