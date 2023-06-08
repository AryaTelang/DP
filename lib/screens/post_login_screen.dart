import 'package:bachat_cards/Drawer/drawer.dart';
import 'package:bachat_cards/controllers/post_login_screen_controller.dart';
import 'package:bachat_cards/screens/bottom_nav_bar_screens/account_screen.dart';
import 'package:bachat_cards/screens/bottom_nav_bar_screens/dashboard_screen.dart';
import 'package:bachat_cards/screens/bottom_nav_bar_screens/home_screen.dart';
import 'package:bachat_cards/screens/offers_screens/offers_screen.dart';
import 'package:bachat_cards/screens/rewards_screens/rewards_screen.dart';
import 'package:bachat_cards/screens/card_screens/view_cards_screen.dart';
import 'package:bachat_cards/sevrices/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/home_screen_controller.dart';
import '../theme/theme.dart';

class PostLoginScreen extends StatefulWidget {
  const PostLoginScreen({super.key});

  static const routeName = 'postloginScreen';

  @override
  State<PostLoginScreen> createState() => _PostLoginScreenState();
}

class _PostLoginScreenState extends State<PostLoginScreen> {
  final postLoginScreenController = Get.find<PostLoginScreenController>();

  final List<Widget> mainScreens = [
    const HomeScreen(),
    const DashboardScreen(),
    const OffersScreen(),
    const RewardsScreen(),
    const AccountScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          centerTitle: false,
          title: Obx(() => Text(
                'Points: ${Get.find<HomeScreenController>().userBalance}',
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff263238)),
              )),
          actions: [
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Get.to(() => const ViewCardsScreen());
              },
              icon: SvgPicture.asset(
                'assets/images/card.svg',
                height: 40,
                width: 40,
              ),
            ),
          ]),
      resizeToAvoidBottomInset: true,
      drawer: SharedDrawer(key: const Key('Drawer'),),
      body: SafeArea(
          child: PageView(
        controller: postLoginScreenController.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: mainScreens,
      )),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          onTap: (value) {
            postLoginScreenController.updateIndex(value);
            switch (value) {
              case 0:
                AnalyticsService.logScreenName(screenName: 'Home');
                break;
              case 1:
                AnalyticsService.logScreenName(screenName: 'Dashboard');
                break;
              case 2:
                AnalyticsService.logScreenName(screenName: 'Offers');
                break;
              case 3:
                AnalyticsService.logScreenName(screenName: 'Rewards');
                break;
              case 4:
                AnalyticsService.logScreenName(screenName: 'Account');
                break;
            }
          },
          fixedColor: primaryColor,
          currentIndex: postLoginScreenController.index.value,
          showSelectedLabels: true,
          items: [
            BottomNavigationBarItem(
                icon: ImageIcon(
                  const AssetImage(
                    'assets/images/home.png',
                  ),
                  color: postLoginScreenController.index.value == 0
                      ? primaryColor
                      : null,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
              icon: ImageIcon(
                const AssetImage(
                  'assets/images/dashboard.png',
                ),
                color: postLoginScreenController.index.value == 1
                    ? primaryColor
                    : null,
              ),
              label: 'My Cards',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                const AssetImage(
                  'assets/images/offers.png',
                ),
                color: postLoginScreenController.index.value == 2
                    ? primaryColor
                    : null,
              ),
              label: 'Offers',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                const AssetImage(
                  'assets/images/rewards.png',
                ),
                color: postLoginScreenController.index.value == 3
                    ? primaryColor
                    : null,
              ),
              label: 'Cashback',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                const AssetImage(
                  'assets/images/account.png',
                ),
                color: postLoginScreenController.index.value == 4
                    ? primaryColor
                    : null,
              ),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
