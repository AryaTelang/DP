import 'package:bachat_cards/appbar/appbar.dart';
import 'package:bachat_cards/controllers/rewards_screen_controller.dart';
import 'package:bachat_cards/screens/rewards_screens/redeem_points_screen.dart';
import 'package:bachat_cards/wdigets/rewards_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/rewards.dart';
import '../../sevrices/shared_prefs.dart';
import '../../theme/theme.dart';

class FilterRewardsScreen extends StatelessWidget {
  FilterRewardsScreen({super.key, required this.filterName});

  final String filterName;
  final rewardsScreenController = Get.find<RewardsScreenController>();
  final Dio dio = Dio(BaseOptions(
      headers: {'Authorization': 'Bearer ${SharedPrefs.getToken()}'}));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SharedAppBar(
          appBar: AppBar(),
          title: Text(
            filterName,
            style: poppinsSemiBold18.copyWith(color: Colors.black),
          ),
        ),
        body: SafeArea(
          child: FutureBuilder(
            future:
                rewardsScreenController.getBrandsByCategory(filterName, dio),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Some error occured'),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LayoutBuilder(builder: (context, constraints) {
                  return GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: constraints.maxWidth > 600 ? 3 : 2,
                          childAspectRatio: 0.65,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 16),
                      itemCount: rewardsScreenController.filteredList.length,
                      itemBuilder: ((context, i) {
                        final Brands brand =
                            rewardsScreenController.filteredList[i];
                        String brandImage = '';
                        if (brand.gyftrImage != null &&
                            brand.gyftrImage != '') {
                          brandImage = brand.gyftrImage!;
                        } else {
                          if (brand.pineImage == null) {
                            brandImage = '';
                          } else {
                            brandImage = brand.pineImage!.mobile!;
                          }
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
                            imageLink: brand.brandImages!.isNotEmpty
                                ? brand.brandImages![0]
                                : 'https://gbdev.s3.amazonaws.com/uat/product/CNPIN/d/small_image/324_microsite.png',
                            discountPercentage: brand.discountOthers ?? 0,
                          ),
                        );
                      }));
                }),
              );
            }),
          ),
        ));
  }
}
