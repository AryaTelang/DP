import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:bachat_cards/bindings/bindings.dart';
import 'package:bachat_cards/screens/auth_screens/is_new_user_screen.dart';
import 'package:bachat_cards/screens/card_screens/view_cards_screen.dart';
import 'package:bachat_cards/screens/contact_us.dart';
import 'package:bachat_cards/screens/drawer_screens/trasactions_screen.dart';
import 'package:bachat_cards/screens/drawer_screens/vouchers_screen.dart';
import 'package:bachat_cards/screens/orders_screens/orders_screen.dart';
import 'package:bachat_cards/screens/profile_screen.dart';
import 'package:bachat_cards/sevrices/shared_prefs.dart';
import 'package:bachat_cards/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controllers/post_login_screen_controller.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 120,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    height: 100.0,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 6.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          const Text(
                            'Welcome',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Color(0xff2800FE),
                                fontSize: 20),
                          ),
                          Obx(() => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 100),
                                  child: Text(
                                    Get.find<PostLoginScreenController>()
                                                .userProfile
                                                .value
                                                .userInfo !=
                                            null
                                        ? Get.find<PostLoginScreenController>()
                                                .userProfile
                                                .value
                                                .userInfo!
                                                .firstName ??
                                            ''
                                        : '',
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 24),
                                    softWrap: true,
                                  ),
                                ),
                              ))
                        ]),
                  ),
                ),
                Positioned(
                  right: 20,
                  child: CircleAvatar(
                    radius: 60,
                    child: Image.asset('assets/images/sample_profile.png'),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 6.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, -1.0),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  _accountRows('Transaction History',
                      'assets/images/transaction_history.svg', () {
                    Get.to(() => TransactionsScreen());
                  }),
                  _accountRows('My Cards', 'assets/images/my_cards.svg', () {
                    Get.to(() => const ViewCardsScreen());
                  }),
                  _accountRows('Profile', 'assets/images/account.svg', () {
                    Get.to(() => const ProfileScreen());
                  }),
                  _accountRows('My Vouchers', 'assets/images/my_vouchers.svg',
                      () {
                    Get.to(() => VouchersScreen());
                  }),
                  _accountRows('My Orders', 'assets/images/my_orders.svg', () {
                    Get.to(() => const OrdersScreen());
                  }),
                  // _accountRows(
                  //     'My KYC status', 'assets/images/kyc_status.svg', () {}),
                  InkWell(
                    onTap: () async {
                      try {
                        if (await SharedPrefs.deleteToken() &&
                            await SharedPrefs.deleteUserId() &&
                            await SharedPrefs.deletePhone()) {
                          await Amplify.Auth.signOut();
                          Get.reloadAll();
                          Get.offAll(() => const IsNewUserScreen(),
                              binding: InitialBindigs());
                        }
                      } catch (e) {
                        Get.snackbar('Error', e.toString());
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.logout),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Logout',
                            style: poppinsMedium14.copyWith(
                                fontSize: 15, color: Colors.black),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_right_outlined,
                            size: 30,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const ContactUsScreen());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xFFE4F1ED)),
                      padding: const EdgeInsets.all(20),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/support.png'),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                'How can we help you?',
                                style: poppinsSemiBold18.copyWith(
                                    fontSize: 16,
                                    color: const Color(0xFF10A8A6)),
                              ),
                            )
                          ]),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Bachat Cards',
                    style: poppinsBold20.copyWith(color: primaryColor),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _accountRows(String title, String iconPath, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            SvgPicture.asset(iconPath),
            const SizedBox(
              width: 8,
            ),
            Text(
              title,
              style:
                  poppinsMedium14.copyWith(fontSize: 15, color: Colors.black),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_right_outlined,
              size: 30,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}
