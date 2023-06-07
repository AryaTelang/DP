import 'package:bachat_cards/Constants/constants.dart';
import 'package:bachat_cards/appbar/appbar.dart';
import 'package:bachat_cards/controllers/redeem_coupon_screen_controller.dart';
import 'package:bachat_cards/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class RedeemCouponScreen extends StatelessWidget {
  RedeemCouponScreen(
      {super.key,
      this.redemptionProcess,
      this.escalationMatrix,
      this.terms,
      this.description,
      this.brandLogo,
      required this.code});

  String code = '';
  String? redemptionProcess = '';
  String? escalationMatrix = '';
  String? terms = '';
  String? description = '';
  String? brandLogo = '';

  final redeemCouponScreenController = Get.put(RedeemCouponScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(
        appBar: AppBar(),
        title: Text(
          'Redeem Coupon',
          style: poppinsSemiBold18.copyWith(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Expanded(
                child: Obx(() => _choiceChip(
                    'Redeemption Process', RedeemCuponSelectedTab.process)),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Obx(() => _choiceChip(
                    'Escalation Matrix', RedeemCuponSelectedTab.matrix)),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Obx(() => _choiceChip(
                    'Terms & Conditions', RedeemCuponSelectedTab.tc)),
              )
            ],
          ),
          _spacer16(),
          Obx(() => Html(
                data: redeemCouponScreenController.selectedTab.value ==
                        RedeemCuponSelectedTab.process
                    ? redemptionProcess ?? ''
                    : redeemCouponScreenController.selectedTab.value ==
                            RedeemCuponSelectedTab.matrix
                        ? escalationMatrix ?? ''
                        : terms ?? '',
              )),
          _spacer16(),
          _spacer16(),
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(border: Border.all()),
              child: CachedNetworkImage(
                imageUrl: brandLogo ?? '',
                errorWidget: (context, url, error) => SizedBox(
                    height: 100,
                    child: SvgPicture.asset('assets/images/errorImage.svg')),
              ),
            ),
          ),
          _spacer16(),
          Center(
            child: Html(
              data: description ?? '',
            ),
          ),
          _spacer16(),
          _spacer16(),
          Center(
            child: DottedBorder(
              borderType: BorderType.Rect,
              dashPattern: const [10, 6],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  code,
                  style:
                      const TextStyle(fontSize: 8, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          _spacer16(),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Tap to copy code'),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: code)).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Code copied to clipboard"),
                    ),
                  );
                });
              },
            ),
          ),
          // _spacer16(),
          // Center(
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       elevation: 0,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //     ),
          //     child: const Text('Invite Friends'),
          //     onPressed: () {
          //       Get.to(() => InviteScreen());
          //     },
          //   ),
          // )
        ]),
      )),
    );
  }

  _spacer16() {
    return const SizedBox(
      height: 16,
    );
  }

  _choiceChip(String text, RedeemCuponSelectedTab selectedTab) {
    return ChoiceChip(
      label: FittedBox(
        child: Text(
          text,
          style: poppinsMedium14.copyWith(
              color:
                  redeemCouponScreenController.selectedTab.value == selectedTab
                      ? Colors.white
                      : Colors.black),
        ),
      ),
      selected: redeemCouponScreenController.selectedTab.value == selectedTab,
      onSelected: (value) {
        if (value) {
          redeemCouponScreenController.selectedTab.value = selectedTab;
        }
      },
      selectedColor: primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
