import 'package:bachat_cards/screens/auth_screens/login_screen.dart';
import 'package:bachat_cards/screens/auth_screens/signup_screen.dart';
import 'package:bachat_cards/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class IsNewUserScreen extends StatelessWidget {
  const IsNewUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: -MediaQuery.of(context).size.height / 5 + 50,
              left: 10,
              child: CircleAvatar(
                backgroundColor: const Color(0xffB5A7FF),
                radius: MediaQuery.of(context).size.width / 1.6,
              )),
          Positioned(
              bottom: -MediaQuery.of(context).size.height / 3.5,
              right: -MediaQuery.of(context).size.width / 2,
              child: CircleAvatar(
                backgroundColor: const Color(0xffB5A7FF),
                radius: MediaQuery.of(context).size.width / 2,
              )),
          LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        SvgPicture.asset(
                          'assets/images/hello.svg',
                          width: MediaQuery.of(context).size.width - 20,
                          height: MediaQuery.of(context).size.width - 20,
                        ),
                        const Spacer(),
                        const Text(
                          'Ready to get started',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              fontSize: 24),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(() => SignupScreen());
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              minimumSize: const Size.fromHeight(44),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          child: Text(
                            'New User',
                            style: latoRegular16.copyWith(color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            Get.to(() => LoginScreen());
                          },
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: primaryColor),
                              minimumSize: const Size.fromHeight(44),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              )),
                          child: const Text(
                            'Existing User',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                color: primaryColor),
                          ),
                        ),
                        const Spacer(),
                        const Spacer()
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
