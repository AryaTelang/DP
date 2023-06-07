import 'dart:io';

import 'package:bachat_cards/controllers/login_screen_controler.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../appbar/appbar.dart';
import '../../theme/theme.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final loginController = Get.find<LoginController>();
  RxString code = ''.obs;
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    listenForCode();
  }

  void listenForCode() async {
    SmsAutoFill().listenForCode;
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isAndroid
          ? null
          : SharedAppBar(
              appBar: AppBar(),
            ),
      body: Stack(
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
          Center(
              child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SvgPicture.asset('assets/images/otp.svg'),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Enter OTP',
                      style: poppinsSemiBold24,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFieldPinAutoFill(
                    key: const Key('OTP'),
                    style: textfieldStyle,
                    currentCode: code.value,
                    onCodeChanged: (val) {
                      code.value = val;
                      loginController.otpController.text = val;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.smartphone),
                      fillColor: const Color(0xFFF4F6FA),
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8)),
                      hintText: 'Enter OTP',
                      hintStyle: textfieldStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Obx(
                    () => ElevatedButton(
                      onPressed: () {
                        if (code.isNotEmpty) {
                          loginController.isLoading.value = true;
                          loginController.verifyOtp(
                              loginController.otpController.text, dio);
                        } else {
                          Get.snackbar('Error', 'Please enter OTP');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          minimumSize: const Size.fromHeight(44),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      child: loginController.isLoading.value
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
                              'Verify OTP',
                              style: latoBold16,
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 30,
                    child: Obx(
                      () => loginController.isResendLoading.value
                          ? const SizedBox(
                              width: 30, child: CircularProgressIndicator())
                          : RichText(
                              text: TextSpan(
                                  text: 'Didn\'t receive code?',
                                  style: latoRegular16.copyWith(
                                      fontSize: 14, color: grey),
                                  children: [
                                    TextSpan(
                                        recognizer: loginController
                                            .tapGestureRecognizer,
                                        text: ' Request again',
                                        style: latoRegular16.copyWith(
                                            color: Colors.black, fontSize: 14))
                                  ]),
                            ),
                    ),
                  )
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
