import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:bachat_cards/controllers/post_login_screen_controller.dart';
import 'package:bachat_cards/screens/auth_screens/is_new_user_screen.dart';
import 'package:bachat_cards/sevrices/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../bindings/bindings.dart';
import '../screens/drawer_screens/trasactions_screen.dart';
import '../screens/drawer_screens/vouchers_screen.dart';
import '../sevrices/shared_prefs.dart';

class SharedDrawer extends StatelessWidget {
  SharedDrawer({super.key});

  final postLoginScreenController = Get.find<PostLoginScreenController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: ListView(children: [
          ListTile(
            title: const Text('Home'),
            leading: const Icon(
              Icons.home,
              color: Colors.black,
            ),
            onTap: () {
              AnalyticsService.logScreenName(screenName: 'Home');
              postLoginScreenController.updateIndex(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Dashboard'),
            leading: Image.asset(
              'assets/images/dashboard.png',
              color: Colors.black,
            ),
            onTap: () {
              AnalyticsService.logScreenName(screenName: 'Dashboard');
              postLoginScreenController.updateIndex(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Offers'),
            leading: Image.asset(
              'assets/images/offers.png',
              color: Colors.black,
            ),
            onTap: () {
              AnalyticsService.logScreenName(screenName: 'Offers');
              postLoginScreenController.updateIndex(2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Rewards'),
            leading: Image.asset(
              'assets/images/rewards.png',
              color: Colors.black,
            ),
            onTap: () {
              AnalyticsService.logScreenName(screenName: 'Rewards');
              postLoginScreenController.updateIndex(3);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('My Transactions'),
            leading: SvgPicture.asset(
              'assets/images/credit_card.svg',
              height: 16,
            ),
            onTap: () {
              AnalyticsService.logScreenName(screenName: 'Transactions');
              Navigator.pop(context);
              Get.to(() => TransactionsScreen());
            },
          ),
          ListTile(
            title: const Text('My Vouchers'),
            leading: SvgPicture.asset(
              'assets/images/credit_card.svg',
              height: 16,
            ),
            onTap: () {
              AnalyticsService.logScreenName(screenName: 'Vouchers');
              Navigator.pop(context);
              Get.to(() => VouchersScreen());
            },
          ),
          ListTile(
            title: const Text('Account'),
            leading: Image.asset(
              'assets/images/account.png',
              color: Colors.black,
            ),
            onTap: () {
              AnalyticsService.logScreenName(screenName: 'Account');
              postLoginScreenController.updateIndex(4);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
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
          ),
        ]),
      ),
    );
  }
}
