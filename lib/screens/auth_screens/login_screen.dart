import 'dart:io';

import 'package:bachat_cards/appbar/appbar.dart';
import 'package:bachat_cards/controllers/login_screen_controler.dart';
import 'package:bachat_cards/screens/auth_screens/signup_screen.dart';
import 'package:bachat_cards/theme/theme.dart';
import 'package:bachat_cards/wdigets/new_background.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final loginScreenController = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();
  final Dio dio = Dio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: Platform.isAndroid
          ? null
          : SharedAppBar(
        appBar: AppBar(),
      ),
      body: BackgroundWidget(childWidget: Stack(
        children: [
          Positioned(
              top: -MediaQuery.of(context).size.height / 4,
              right: MediaQuery.of(context).size.width / 3,
              child: CircleAvatar(
                backgroundColor: const Color(0xffB5A7FF),
                radius: MediaQuery.of(context).size.width / 1.8,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Image.asset('assets/images/login.png'),
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'Login',
                            style: poppinsSemiBold24,
                          ),
                        ),
                        const Spacer(),
                        Form(
                          key: _formKey,
                          child: PhoneFormFieldHint(
                            key:const Key('Phone'),
                            autoFocus: true,
                            validator: (value) {
                              if (value.length != 10 && value.length != 13) {
                                return 'Please enter a valid phone numner';
                              }
                              return null;
                            },
                            controller:
                            loginScreenController.phoneEditingController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.smartphone),
                              fillColor: Color(0xFFF4F6FA),
                              filled: true,
                              border: InputBorder.none,
                              hintText: 'Please enter your mobile number',
                              hintStyle: textfieldStyle,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Obx(
                              () => ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                loginScreenController.isLoading.value = true;
                                if (loginScreenController
                                    .phoneEditingController.text.length ==
                                    13) {
                                  loginScreenController.login(
                                      loginScreenController
                                          .phoneEditingController.text,
                                      dio);
                                } else if (loginScreenController
                                    .phoneEditingController.text.length ==
                                    10) {
                                  loginScreenController.login(
                                      '+91${loginScreenController.phoneEditingController.text}',
                                      dio);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                minimumSize: const Size.fromHeight(44),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            child: loginScreenController.isLoading.value
                                ? const Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                            )
                                : const Text(
                              'Send OTP',
                              style: latoBold16,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Get.to(() => SignupScreen()),
                          child: const Text('Sign Up'),
                        ),
                        const SizedBox(
                          height: 16,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      )),
    );
  }
}
