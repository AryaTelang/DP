import 'package:bachat_cards/screens/auth_screens/login_screen.dart';
import 'package:bachat_cards/screens/payment_status_screens/fail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Constants/constants.dart';
import '../../controllers/post_login_screen_controller.dart';
import '../../sevrices/firebase_analytics.dart';
import '../../theme/theme.dart';
import 'kyc_details_screen.dart';

class KYCNew extends StatefulWidget {
  const KYCNew({Key? key}) : super(key: key);

  @override
  State<KYCNew> createState() => _KYCNewState();
}

class _KYCNewState extends State<KYCNew> {
  final postLoginScreenController = Get.find<PostLoginScreenController>();

  var size, height, width;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return SafeArea(
        child: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xff7C64FF), Color(0xff130078)])),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              AnalyticsService.logScreenName(screenName: 'Home');
              postLoginScreenController.updateIndex(0);
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: height / 4,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            offset: Offset(2, 2),
                            blurRadius: 10,
                            spreadRadius: 2)
                      ],
                      color: Colors.white),
                  width: width,
                  height: 700,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15)),
                              Text(
                                "KYC Status",
                                style: TextStyle(
                                  color: Color(0xff263238),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height / 11,
                        ),
                        Center(
                          child: Container(
                            width: width * 0.9,
                            height: height / 4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      blurStyle: BlurStyle.normal,
                                      color: Colors.grey,
                                      offset: Offset(2, 2),
                                      blurRadius: 5,
                                      spreadRadius: 1)
                                ],
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Align(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: Text(
                                        "Min KYC",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Color(0xff6E6BFF)),
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      "By paying a minimal fees pf Rs 7 + Gst you can have your minimum KYC done."),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: SizedBox(
                                          width: 200,
                                          child: Text(
                                              "By completing minimum KYC you can load your multi loadable card with a maximum of Rs 10,000."),
                                        ),
                                      ),
                                      SizedBox(
                                          width: 90,
                                          child: ElevatedButton(
                                            onPressed: () => Get.to(
                                                () => const KYCDetailsScreen(
                                                      kycType: KYCType.min,
                                                    )),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xFF0056D2),
                                              foregroundColor: Colors.black,
                                            ),
                                            child: Text(
                                              "Initiate",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height / 25,
                        ),
                        Center(
                          child: Container(
                            width: width * 0.9,
                            height: height / 4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      blurStyle: BlurStyle.normal,
                                      color: Colors.grey,
                                      offset: Offset(2, 2),
                                      blurRadius: 5,
                                      spreadRadius: 1)
                                ],
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Align(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: Text(
                                        "Full KYC",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Color(0xff6E6BFF)),
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      "By paying a full fees of Rs 24 + Gst you can have your full KYC done."),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: SizedBox(
                                              width: 200,
                                              child: Text(
                                                  " By completing Full KYC you can load your multi loadable card with a maximum of Rs 2 Lac."))),
                                      SizedBox(
                                          width: 90,
                                          child: ElevatedButton(
                                            onPressed: () =>
                                                Get.to(() => KYCDetailsScreen(
                                                      kycType: KYCType.max,
                                                    )),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xFF0056D2),
                                              foregroundColor: Colors.black,
                                            ),
                                            child: Text(
                                              "Initiate",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
        bottomNavigationBar: Obx(
          () => Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      blurStyle: BlurStyle.normal,
                      color: Colors.grey,
                      offset: Offset(2, 2),
                      blurRadius: 5,
                      spreadRadius: 1)
                ],
                color: Colors.white),
            child: BottomNavigationBar(
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
        ),
      ),
    ));
  }
}
