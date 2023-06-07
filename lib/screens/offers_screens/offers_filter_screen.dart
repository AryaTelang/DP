import 'package:bachat_cards/appbar/appbar.dart';
import 'package:bachat_cards/controllers/offers_screen_controller.dart';
import 'package:bachat_cards/screens/offers_screens/redeem_coupon_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/theme.dart';
import '../../wdigets/gift_card_item_widget.dart';

class OffersFilterScreen extends StatefulWidget {
  const OffersFilterScreen({super.key, required this.filterName});

  final String filterName;

  @override
  State<OffersFilterScreen> createState() => _OffersFilterScreenState();
}

class _OffersFilterScreenState extends State<OffersFilterScreen> {
  final offersController = Get.find<OffersController>();

  @override
  Widget build(BuildContext context) {
    offersController.getFilteredOffers(widget.filterName);
    return Scaffold(
      appBar: SharedAppBar(
        appBar: AppBar(),
        title: Text(widget.filterName,
            style: poppinsSemiBold18.copyWith(color: Colors.black)),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: offersController.filteredList.isEmpty
              ? const Center(
                  child: Text('No offers found for selected filter'),
                )
              : LayoutBuilder(builder: (context, constraints) {
                  if (constraints.maxWidth < 600) {
                    return ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 16,
                      ),
                      shrinkWrap: true,
                      itemCount: offersController.filteredList.length,
                      itemBuilder: ((context, index) => GiftCardItem(
                            onClick: () => Get.to(() => RedeemCouponScreen(
                                  redemptionProcess: offersController
                                          .filteredList[index]
                                          .offerDetails!
                                          .redemptionProcess ??
                                      '',
                                  escalationMatrix: offersController
                                          .filteredList[index]
                                          .offerDetails!
                                          .escalationMatrix ??
                                      '',
                                  terms: offersController.filteredList[index]
                                          .offerDetails!.termAndCondition ??
                                      '',
                                  code: offersController
                                          .filteredList[index].code ??
                                      '',
                                  brandLogo: offersController
                                          .filteredList[index]
                                          .offerDetails!
                                          .logoImageLink ??
                                      '',
                                  description: offersController
                                          .filteredList[index]
                                          .offerDetails!
                                          .description ??
                                      '',
                                )),
                            description: offersController.filteredList[index]
                                    .offerDetails!.description ??
                                '',
                            expiry: offersController.filteredList[index]
                                    .offerDetails!.endDateTime ??
                                '',
                            brandImage: offersController.filteredList[index]
                                    .offerDetails!.imageLink ??
                                '',
                            brandLogoLink: offersController.filteredList[index]
                                    .offerDetails!.logoImageLink ??
                                offersController.filteredList[index]
                                    .offerDetails!.mobileImageLink ??
                                '',
                            brandName:
                                offersController.filteredList[index].title ??
                                    '',
                          )),
                    );
                  } else {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16),
                      itemCount: offersController.electronicsOffers.length,
                      itemBuilder: ((context, index) => GiftCardItem(
                            onClick: () => Get.to(() => RedeemCouponScreen(
                                  redemptionProcess: offersController
                                          .filteredList[index]
                                          .offerDetails!
                                          .redemptionProcess ??
                                      '',
                                  escalationMatrix: offersController
                                          .filteredList[index]
                                          .offerDetails!
                                          .escalationMatrix ??
                                      '',
                                  terms: offersController.filteredList[index]
                                          .offerDetails!.termAndCondition ??
                                      '',
                                  code: offersController
                                          .filteredList[index].code ??
                                      '',
                                  brandLogo: offersController
                                          .filteredList[index]
                                          .offerDetails!
                                          .logoImageLink ??
                                      '',
                                  description: offersController
                                          .filteredList[index]
                                          .offerDetails!
                                          .description ??
                                      '',
                                )),
                            description: offersController.filteredList[index]
                                    .offerDetails!.description ??
                                '',
                            expiry: offersController.filteredList[index]
                                    .offerDetails!.endDateTime ??
                                '',
                            brandImage: offersController.filteredList[index]
                                    .offerDetails!.imageLink ??
                                '',
                            brandLogoLink: offersController.filteredList[index]
                                    .offerDetails!.logoImageLink ??
                                offersController.filteredList[index]
                                    .offerDetails!.mobileImageLink ??
                                '',
                            brandName:
                                offersController.filteredList[index].title ??
                                    '',
                          )),
                    );
                  }
                })),
    );
  }
}
