import 'package:bachat_cards/screens/payment_status_screens/fail_screen.dart';
import 'package:bachat_cards/screens/payment_status_screens/success_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Constants/constants.dart';
import '../sevrices/shared_prefs.dart';

class TempPaytm extends StatelessWidget {
  TempPaytm(
      {super.key,
      required this.orderId,
      required this.amount,
      this.kycType,
      this.paymentType,
      this.name,
      required this.type});

  final String orderId;
  final CardType? paymentType;
  final String amount;
  final String type;
  final KYCType? kycType;
  final String? name;
  final Dio dio = Dio(BaseOptions(
      headers: {'Authorization': 'Bearer ${SharedPrefs.getToken()}'}));

  Future<void> sendResponse(String status) async {
    try {
      await dio.post('${Constants.url}/mbc/v1/order/hook',
          data: {"status": status, "orderId": orderId, "type": type});
      if (status == "C") {
        Get.off(() => SuccessScreen(
              orderId: orderId,
              type: paymentType,
              kycType: kycType,
              name: name,
            ));
      } else {
        Get.off(() => const FailScreen());
      }
    } on DioError catch (e) {
      if (kDebugMode) print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Order Id : $orderId'),
          const SizedBox(
            height: 16,
          ),
          Text('Amount : \u{20B9}$amount'),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
              onPressed: () async {
                await sendResponse('C');
              },
              child: const Text('Success')),
          OutlinedButton(
              onPressed: () async {
                await sendResponse('F');
              },
              child: const Text('Failure'))
        ],
      )),
    );
  }
}
