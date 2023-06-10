import 'package:bachat_cards/Constants/constants.dart';
import 'package:bachat_cards/screens/card_screens/kyc_details_screen.dart';
import 'package:bachat_cards/screens/card_screens/kycnew.dart';
import 'package:bachat_cards/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../appbar/appbar.dart';

class KYCScreen extends StatelessWidget {
  const KYCScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(
        title:
            Text("KYC", style: poppinsSemiBold18.copyWith(color: Colors.black)),
        appBar: AppBar(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "new screen",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Color(0xff0056D2),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => KYCNew()));
                },
              ),
              const Text(
                'To get a multi-loadable card you must do a KYC (Min KYC ,Max KYC)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,fontFamily: "Poppins"),
              ),
              const SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () => Get.to(() => const KYCDetailsScreen(
                      kycType: KYCType.max,
                    )),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffF5F5FF),
                    border: Border.all(color: secondaryColor, width: 0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Maximum KYC",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: Color(0xff3012E8)),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              _text("KYC charges (Rs24+GST%)"),
                              _text("Maximum monthly limit Rs 2Lac"),
                              _text("Pan card mandatory"),
                              _text(
                                  "passport, adhaar , driving license (any one of the documents mentioned) ")
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 250,
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(16))),
                        child: const Icon(
                          Icons.arrow_right_alt,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () => Get.to(() => const KYCDetailsScreen(
                      kycType: KYCType.min,
                    )),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffF5F5FF),
                    border: Border.all(color: secondaryColor, width: 0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Minimum KYC",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: Color(0xff3012E8)),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              _text("KYC needed (7rs + GST%)"),
                              _text("Maximum monthly limit Rs 10,000"),
                              _text(
                                  "Aadhar card is mandatory (pan card optional)")
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 200,
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(16))),
                        child: const Icon(
                          Icons.arrow_right_alt,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _text(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        "\u2022 $text",
        style: const TextStyle(
            fontFamily: "Poppins", fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}
