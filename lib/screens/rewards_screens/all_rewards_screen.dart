import 'package:bachat_cards/appbar/appbar.dart';
import 'package:bachat_cards/controllers/rewards_screen_controller.dart';
import 'package:bachat_cards/screens/rewards_screens/redeem_points_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/rewards.dart';
import '../../theme/theme.dart';
import '../../wdigets/rewards_item.dart';

class AllRewardsScreen extends StatefulWidget {
  const AllRewardsScreen({super.key, required this.dealName});

  final String dealName;

  @override
  State<AllRewardsScreen> createState() => _AllRewardsScreenState();
}

class _AllRewardsScreenState extends State<AllRewardsScreen> {
  final rewardsScreenController = Get.find<RewardsScreenController>();
  List<Brands> rewards = <Brands>[];

  @override
  void initState() {
    for (int i = 0; i < rewardsScreenController.rewards.length; i++) {
      if (rewardsScreenController.rewards[i].title != null &&
          rewardsScreenController.rewards[i].title!.toLowerCase() ==
              widget.dealName.toLowerCase()) {
        setState(() {
          rewards.addAll(rewardsScreenController.rewards[i].brands!);
        });
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SharedAppBar(
          appBar: AppBar(),
          title: Text(
            '${widget.dealName} deals',
            style: poppinsSemiBold18.copyWith(color: Colors.black),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: LayoutBuilder(builder: (context, constraints) {
            return GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: constraints.maxWidth > 600 ? 3 : 2,
                    childAspectRatio: 0.65,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 16),
                itemCount: rewards.length,
                itemBuilder: ((context, i) {
                  final Brands brand = rewards[i];

                  String brandImage = '';
                  if (brand.gyftrImage != '') {
                    brandImage = brand.gyftrImage!;
                  } else {
                    brandImage = brand.pineImage!.mobile!;
                  }
                  return GestureDetector(
                    onTap: () => Get.to(() => RedeemPointsScreen(
                          brandId: brand.sId ?? '',
                          // balance: Get.find<PostLoginScreenController>()
                          //         .userProfile
                          //         .value
                          //         .userInfo!
                          //         .rewardBalance ??
                          //     0.0,
                        )),
                    child: RewardsItem(
                      brandName: brand.name ?? '',
                      brandLogoLink: brandImage,
                      imageLink: brand.brandImages![0],
                      discountPercentage: brand.discountOthers ?? 0,
                    ),
                  );
                }));
          }),
        ));
  }
}
