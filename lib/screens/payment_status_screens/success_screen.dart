import 'dart:io';

import 'package:bachat_cards/controllers/home_screen_controller.dart';
import 'package:bachat_cards/screens/orders_screens/orders_screen.dart';
import 'package:bachat_cards/theme/theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Constants/constants.dart';
import '../../sevrices/shared_prefs.dart';
import '../card_screens/web_view.dart';
import '../temporary_paytm.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen(
      {super.key, required this.orderId, this.type, this.kycType, this.name});

  final String orderId;
  final CardType? type;
  final KYCType? kycType;
  final String? name;

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  late TapGestureRecognizer _tapRecognizer;
  var isLoading = false.obs;
  Dio dio = Dio(BaseOptions(
      headers: {'Authorization': 'Bearer ${SharedPrefs.getToken()}'}));

  Future<void> initiateKyc() async {
    isLoading.value = true;
    try {
      final response = await dio
          .post('${Constants.url}/mbc/v1/card/initiateKyc', data: {
        'phoneNumber': SharedPrefs.getPhoneNumber().substring(3),
        'name': widget.name
      });
      if (response.data['alreadyDone'] != null) {
        Get.snackbar('Info',
            "The ${response.data['alreadyDone']} KYC for this mobile number has already been done");
      }
      if (response.data['link'] != null) {
        _launchUrl(response.data['link']);
      } else if (response.data['orderId'] != null) {
        Get.to(() => TempPaytm(
            orderId: response.data['orderId'], amount: "24", type: "kyc"));
      }
    } on DioError catch (e) {
      debugPrint(e.response.toString());
    }
    isLoading.value = false;
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not launch external browser');
    }
  }

  Future<void> initiateMinKYC() async {
    isLoading.value = true;
    try {
      final response = await dio
          .post('${Constants.url}/mbc/v1/card/initiateMinKyc', data: {
        'phoneNumber': SharedPrefs.getPhoneNumber().substring(3),
        'name': widget.name
      });
      if (response.data['alreadyDone'] != null) {
        Get.snackbar('Info',
            "The ${response.data['alreadyDone']} KYC for this mobile number has already been done");
      }
      if (response.data['link'] != null) {
        _launchUrl(response.data['link']);
      } else if (response.data['orderId'] != null) {
        Get.to(() => TempPaytm(
            orderId: response.data['result']['orderId'],
            amount: "7",
            type: "kyc"));
      }
    } on DioError catch (e) {
      debugPrint(e.response.toString());
    }
    isLoading.value = false;
  }

  @override
  void initState() {
    _tapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Get.off(() => const OrdersScreen());
      };
    if (widget.kycType != null) {
      Get.find<HomeScreenController>().getKycStatus(dio);
    }
    super.initState();
  }

  @override
  void dispose() {
    _tapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Platform.isIOS ? AppBar() : null,
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text:
                    'Your ${widget.type == CardType.multiReload ? "request was placed " : "payment was "}',
                style: poppinsBold20.copyWith(color: Colors.black),
                children: [
                  TextSpan(
                    text: 'successfully ',
                    style: poppinsBold20.copyWith(
                      color: Colors.green[500],
                    ),
                  ),
                  if (widget.type != CardType.multiReload)
                    TextSpan(
                        text: 'done !',
                        style: poppinsBold20.copyWith(color: Colors.black))
                ],
              ),
            ),
            _spacer16(),
            Image.asset('assets/images/success.png'),
            _spacer16(),
            _spacer16(),
            if (widget.type != CardType.multiReload)
              RichText(
                text: TextSpan(
                    text: 'Your order ID: ',
                    style: const TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFFC100),
                    ),
                    children: [
                      TextSpan(
                        text: widget.orderId,
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      )
                    ]),
              ),
            _spacer16(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: widget.type == CardType.multiReloadAddAmount
                        ? 'Your paymnet was successful and your card will be loaded withinin next 30 minutes. You can track the order status in my orders in profile or by tapping '
                        : widget.type == CardType.onceReload
                            ? 'Your paymnet was successful and your digital card will be delivered to you withinin next 30 minutes. You can track the order status in my orders in profile or by tapping '
                            : widget.type == CardType.multiReload
                                ? 'Your order was successfully placed and your digital card will be delivered to you withinin next 30 minutes. You can track the order status in my orders in profile or by tapping '
                                : 'Your paymnet was successful and can start the KYC now or later from the home screen',
                    style: latoBold16.copyWith(color: grey),
                    children: [
                      if (widget.type == CardType.multiReloadAddAmount ||
                          widget.type == CardType.onceReload ||
                          widget.type == CardType.multiReload)
                        TextSpan(
                            text: 'here',
                            style: const TextStyle(color: Colors.blue),
                            recognizer: _tapRecognizer)
                    ]),
              ),
            ),
            _spacer16(),
            _spacer16(),
            if (widget.kycType != null)
              OutlinedButton(
                onPressed: () {
                  if (widget.kycType == KYCType.max) {
                    initiateKyc();
                  } else if (widget.kycType == KYCType.min) {
                    initiateMinKYC();
                  }
                },
                child: const Text('Proceed to KYC'),
              ),
            _spacer16(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
              child: const Text(
                'Back to home',
              ),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
                // Get.(PostLoginScreen.routeName, (route) => false);
              },
            ),
          ]),
        ),
      )),
    );
  }

  _spacer16() {
    return const SizedBox(
      height: 16,
    );
  }
}
