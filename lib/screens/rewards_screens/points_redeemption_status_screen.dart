import 'package:bachat_cards/screens/drawer_screens/vouchers_screen.dart';
import 'package:bachat_cards/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PointsRedeemptionStatusScreen extends StatelessWidget {
  const PointsRedeemptionStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Points Redeemption Successful',
                  style: poppinsBold20,
                ),
                _spaceeer16(),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 3,
                  child: Image.asset('assets/images/redeem-points.png'),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  child: Text(
                    'Your giftcard is on the way. You can check you giftcards in my vouchers section or click the button below.',
                    textAlign: TextAlign.center,
                  ),
                ),
                _spaceeer16(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () {
                    Get.off(() => VouchersScreen());
                  },
                  child: const Text('My Vouchers'),
                ),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Back to home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _spaceeer16() {
    return const SizedBox(
      height: 40,
    );
  }
}
