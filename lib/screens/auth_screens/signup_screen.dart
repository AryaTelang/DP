import 'dart:io';

import 'package:bachat_cards/controllers/signup_screen_controller.dart';
import 'package:bachat_cards/screens/auth_screens/login_screen.dart';
import 'package:bachat_cards/wdigets/new_background.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../appbar/appbar.dart';
import '../../theme/theme.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final controller = Get.put(SignUpScreenController());
  final Dio dio = Dio();
  final _formKey = GlobalKey<FormState>();

  InputDecoration textfieldDecoration(IconData icon, String hintText) {
    return InputDecoration(
      prefixIcon: Icon(icon),
      fillColor: const Color(0xFFF4F6FA),
      filled: true,
      border: OutlineInputBorder(
          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
      hintText: hintText,
      hintStyle: textfieldStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: Platform.isAndroid
          ? null
          : SharedAppBar(
              appBar: AppBar(),
            ),
      body: BackgroundWidget(childWidget: LayoutBuilder(

        builder: (context, constraints) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const Spacer(),
                      Image.asset('assets/images/login.png'),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'Welcome',
                          style: poppinsSemiBold24,
                        ),
                      ),
                      const Spacer(),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty || value.length != 10) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                        controller: controller.phoneTextEditingController,
                        keyboardType: TextInputType.phone,
                        style: textfieldStyle,
                        decoration: textfieldDecoration(
                            Icons.smartphone, 'Please enter your phone number'),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                          validator: (val) {
                            if (val!.isEmpty || !val.isValidEmail()) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: textfieldStyle,
                          decoration: textfieldDecoration(Icons.email_outlined,
                              'Please enter your Email ID')),
                      const Spacer(),
                      Row(
                        children: [
                          Obx(
                            (() => Checkbox(
                              fillColor:
                              MaterialStateProperty.resolveWith<Color>(
                                      (states) {
                                    return primaryColor;
                                  }),
                              onChanged: (val) {
                                controller.termsCheck.value = val!;
                              },
                              value: controller.termsCheck.value,
                              materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                            )),
                          ),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                  text: 'I accept the ',
                                  style: latoRegular16.copyWith(
                                      color: Colors.black, fontSize: 14),
                                  children: [
                                    TextSpan(
                                      recognizer:
                                      controller.tapGestureRecognizer,
                                      text: 'terms and conditions',
                                      style: latoRegular16.copyWith(
                                          color: primaryColor, fontSize: 14),
                                    ),
                                    TextSpan(
                                      text: ' of Bachat cards.',
                                      style: latoRegular16.copyWith(
                                          color: Colors.black, fontSize: 14),
                                    )
                                  ]),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Obx(
                            () => ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (controller.termsCheck.value) {
                                controller.isLoading.value = true;
                                controller.startUserSignUp(
                                    '+91${controller.phoneTextEditingController.text}',
                                    controller.emailController.text,
                                    dio);
                              } else {
                                Get.snackbar(
                                    'Info', 'Please check the terms checkbox');
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              minimumSize: const Size.fromHeight(44),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          child: controller.isLoading.value
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
                            'Sign Up',
                            style: latoBold16,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.off(() => LoginScreen()),
                        child: const Text('Login'),
                      ),
                      const SizedBox(
                        height: 16,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      )),
    );
  }
}
