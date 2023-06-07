import 'package:bachat_cards/appbar/appbar.dart';
import 'package:bachat_cards/controllers/offers_screen_controller.dart';
import 'package:bachat_cards/models/offer.dart';
import 'package:bachat_cards/screens/offers_screens/redeem_coupon_screen.dart';
import 'package:bachat_cards/sevrices/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/theme.dart';
import '../../wdigets/gift_card_item_widget.dart';

class SearchOffersScreen extends StatefulWidget {
  const SearchOffersScreen({super.key});

  @override
  State<SearchOffersScreen> createState() => _SearchOffersScreenState();
}

class _SearchOffersScreenState extends State<SearchOffersScreen> {
  final searchController = TextEditingController();
  List<Offer> filteredList = <Offer>[];
  final offersController = Get.find<OffersController>();

  List<Offer> getFilteredList(String query) {
    filteredList.clear();
    for (Offer offer in offersController.offers) {
      if (offer.title != null &&
          offer.title!.toLowerCase().startsWith(query.toLowerCase())) {
        filteredList.add(offer);
      }
    }
    return filteredList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(
        appBar: AppBar(),
        title: Text(
          'Search Offers',
          style: poppinsSemiBold18.copyWith(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          TextField(
              controller: searchController,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    filteredList = getFilteredList(value);
                  });
                }
              },
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(),
                  borderRadius: BorderRadius.circular(10),
                ),
              )),
          const SizedBox(
            height: 16,
          ),
          if (searchController.text.isNotEmpty)
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                if (constraints.maxWidth < 600) {
                  return ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 16,
                    ),
                    itemCount: filteredList.length,
                    itemBuilder: ((context, index) => GiftCardItem(
                          onClick: () {
                            Get.to(() => RedeemCouponScreen(
                                  redemptionProcess: filteredList[index]
                                          .offerDetails!
                                          .redemptionProcess ??
                                      '',
                                  escalationMatrix: filteredList[index]
                                          .offerDetails!
                                          .escalationMatrix ??
                                      '',
                                  terms: filteredList[index]
                                          .offerDetails!
                                          .termAndCondition ??
                                      '',
                                  code: filteredList[index].code ?? '',
                                  brandLogo: filteredList[index]
                                          .offerDetails!
                                          .logoImageLink ??
                                      '',
                                  description: filteredList[index]
                                          .offerDetails!
                                          .description ??
                                      '',
                                ));
                            AnalyticsService.logOffersSearch(
                                offerName: filteredList[index].title ?? '');
                          },
                          description:
                              filteredList[index].offerDetails!.description ??
                                  '',
                          expiry:
                              filteredList[index].offerDetails!.endDateTime ??
                                  '',
                          brandImage:
                              filteredList[index].offerDetails!.imageLink ?? '',
                          brandLogoLink:
                              filteredList[index].offerDetails!.logoImageLink ??
                                  filteredList[index]
                                      .offerDetails!
                                      .mobileImageLink ??
                                  '',
                          brandName: filteredList[index].title ?? '',
                        )),
                  );
                } else {
                  return GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16),
                    itemCount: filteredList.length,
                    itemBuilder: ((context, index) => GiftCardItem(
                          onClick: () {
                            Get.to(() => RedeemCouponScreen(
                                  redemptionProcess: filteredList[index]
                                          .offerDetails!
                                          .redemptionProcess ??
                                      '',
                                  escalationMatrix: filteredList[index]
                                          .offerDetails!
                                          .escalationMatrix ??
                                      '',
                                  terms: filteredList[index]
                                          .offerDetails!
                                          .termAndCondition ??
                                      '',
                                  code: filteredList[index].code ?? '',
                                  brandLogo: filteredList[index]
                                          .offerDetails!
                                          .logoImageLink ??
                                      '',
                                  description: filteredList[index]
                                          .offerDetails!
                                          .description ??
                                      '',
                                ));
                            AnalyticsService.logOffersSearch(
                                offerName: filteredList[index].title ?? '');
                          },
                          description:
                              filteredList[index].offerDetails!.description ??
                                  '',
                          expiry:
                              filteredList[index].offerDetails!.endDateTime ??
                                  '',
                          brandImage:
                              filteredList[index].offerDetails!.imageLink ?? '',
                          brandLogoLink:
                              filteredList[index].offerDetails!.logoImageLink ??
                                  filteredList[index]
                                      .offerDetails!
                                      .mobileImageLink ??
                                  '',
                          brandName: filteredList[index].title ?? '',
                        )),
                  );
                }
              }),
            )
        ]),
      ),
    );
  }
}
