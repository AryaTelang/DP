import 'package:bachat_cards/controllers/offers_screen_controller.dart';
import 'package:bachat_cards/screens/offers_screens/offers_filter_screen.dart';
import 'package:bachat_cards/screens/offers_screens/redeem_coupon_screen.dart';
import 'package:bachat_cards/screens/offers_screens/search_offers_screen.dart';
import 'package:bachat_cards/sevrices/firebase_analytics.dart';
import 'package:bachat_cards/theme/theme.dart';
import 'package:bachat_cards/wdigets/search_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../sevrices/shared_prefs.dart';
import '../../wdigets/gift_card_item_widget.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen>
    with AutomaticKeepAliveClientMixin {
  final offersController = Get.find<OffersController>();

  List<Widget> filterWidgetsList = [
    SvgPicture.asset(
      'assets/images/beauty.svg',
      height: 30,
    ),
    SvgPicture.asset(
      'assets/images/food.svg',
      height: 30,
    ),
    SvgPicture.asset(
      'assets/images/electronics.svg',
      height: 30,
    ),
    SvgPicture.asset(
      'assets/images/grocery.svg',
      height: 30,
    ),
    SvgPicture.asset(
      'assets/images/accessories.svg',
      height: 30,
    ),
    SvgPicture.asset(
      'assets/images/medicine.svg',
      height: 30,
    ),
    SvgPicture.asset(
      'assets/images/apparel.svg',
      height: 30,
    ),
    SvgPicture.asset(
      'assets/images/travel.svg',
      height: 30,
    ),
  ];

  List<String> filterWidgetsText = [
    'Cosmetics',
    'Dining',
    'Electronics',
    'Grocery',
    'Lifetyle',
    'Medicine',
    'Shopping',
    'Travel',
  ];

  final Dio dio = Dio(BaseOptions(
      headers: {'Authorization': 'Bearer ${SharedPrefs.getToken()}'}));

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = (MediaQuery.of(context).size.width) / 4;
    return RefreshIndicator(
      onRefresh: () {
        return offersController.getOffers(dio);
      },
      child: FutureBuilder(
          future: offersController.getOffers(dio),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              return Column(children: [
                GestureDetector(
                    onTap: () {
                      Get.to(() => const SearchOffersScreen());
                    },
                    child: const SearchWidget()),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          direction: Axis.horizontal,
                          children: List.generate(
                            filterWidgetsText.length,
                            (index) => GestureDetector(
                              onTap: () {
                                AnalyticsService.logOfferFilter(
                                    filter: filterWidgetsText[index]);
                                Get.to(
                                  () => OffersFilterScreen(
                                      filterName: filterWidgetsText[index]),
                                );
                              },
                              child: SizedBox(
                                width: size,
                                height: size,
                                child: Card(
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircleAvatar(
                                            radius: MediaQuery.of(context)
                                                        .size
                                                        .width >
                                                    600
                                                ? size / 3
                                                : 24,
                                            backgroundColor:
                                                const Color(0xfff6f6f6),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: filterWidgetsList[index],
                                            )),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Expanded(
                                          child: Text(
                                            filterWidgetsText[index],
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        _spacer16(),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Top offers on dining',
                            style: poppinsSemiBold18,
                          ),
                        ),
                        _spacer16(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: LayoutBuilder(builder: (context, constraints) {
                            if (constraints.maxWidth < 600) {
                              return ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 16,
                                ),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    offersController.foodOffers.length > 4
                                        ? 4
                                        : offersController.foodOffers.length,
                                itemBuilder: ((context, index) => index == 3
                                    ? TextButton(
                                        onPressed: () {
                                          Get.to(() => const OffersFilterScreen(
                                              filterName: 'Dining'));
                                        },
                                        child: const Text('Show more'))
                                    : GiftCardItem(
                                        onClick: () =>
                                            Get.to(() => RedeemCouponScreen(
                                                  redemptionProcess:
                                                      offersController
                                                              .foodOffers[index]
                                                              .offerDetails!
                                                              .redemptionProcess ??
                                                          '',
                                                  escalationMatrix:
                                                      offersController
                                                              .foodOffers[index]
                                                              .offerDetails!
                                                              .escalationMatrix ??
                                                          '',
                                                  terms: offersController
                                                          .foodOffers[index]
                                                          .offerDetails!
                                                          .termAndCondition ??
                                                      '',
                                                  code: offersController
                                                          .foodOffers[index]
                                                          .code ??
                                                      '',
                                                  brandLogo: offersController
                                                          .foodOffers[index]
                                                          .offerDetails!
                                                          .logoImageLink ??
                                                      '',
                                                  description: offersController
                                                          .foodOffers[index]
                                                          .offerDetails!
                                                          .description ??
                                                      '',
                                                )),
                                        description: offersController
                                                .foodOffers[index]
                                                .offerDetails!
                                                .description ??
                                            '',
                                        expiry: offersController
                                                .foodOffers[index]
                                                .offerDetails!
                                                .endDateTime ??
                                            '',
                                        brandImage: offersController
                                                .foodOffers[index]
                                                .offerDetails!
                                                .imageLink ??
                                            '',
                                        brandLogoLink: offersController
                                                .foodOffers[index]
                                                .offerDetails!
                                                .logoImageLink ??
                                            offersController
                                                .foodOffers[index]
                                                .offerDetails!
                                                .mobileImageLink ??
                                            '',
                                        brandName: offersController
                                                .foodOffers[index].title ??
                                            '',
                                      )),
                              );
                            } else {
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 2,
                                        mainAxisSpacing: 16,
                                        crossAxisSpacing: 16),
                                itemCount:
                                    offersController.foodOffers.length > 6
                                        ? 6
                                        : offersController.foodOffers.length,
                                itemBuilder: ((context, index) => index == 5
                                    ? TextButton(
                                        onPressed: () {
                                          Get.to(() => const OffersFilterScreen(
                                              filterName: 'Dining'));
                                        },
                                        child: const Text('Show more'))
                                    : GiftCardItem(
                                        onClick: () =>
                                            Get.to(() => RedeemCouponScreen(
                                                  redemptionProcess:
                                                      offersController
                                                              .foodOffers[index]
                                                              .offerDetails!
                                                              .redemptionProcess ??
                                                          '',
                                                  escalationMatrix:
                                                      offersController
                                                              .foodOffers[index]
                                                              .offerDetails!
                                                              .escalationMatrix ??
                                                          '',
                                                  terms: offersController
                                                          .foodOffers[index]
                                                          .offerDetails!
                                                          .termAndCondition ??
                                                      '',
                                                  code: offersController
                                                          .foodOffers[index]
                                                          .code ??
                                                      '',
                                                  brandLogo: offersController
                                                      .foodOffers[index]
                                                      .offerDetails!
                                                      .logoImageLink,
                                                  description: offersController
                                                          .foodOffers[index]
                                                          .offerDetails!
                                                          .description ??
                                                      '',
                                                )),
                                        description: offersController
                                                .foodOffers[index]
                                                .offerDetails!
                                                .description ??
                                            '',
                                        expiry: offersController
                                                .foodOffers[index]
                                                .offerDetails!
                                                .endDateTime ??
                                            '',
                                        brandImage: offersController
                                            .foodOffers[index]
                                            .offerDetails!
                                            .imageLink,
                                        brandLogoLink: offersController
                                                .foodOffers[index]
                                                .offerDetails!
                                                .logoImageLink ??
                                            offersController.foodOffers[index]
                                                .offerDetails!.mobileImageLink,
                                        brandName: offersController
                                                .foodOffers[index].title ??
                                            '',
                                      )),
                              );
                            }
                          }),
                        ),
                        _spacer16(),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Top offers on shopping',
                            style: poppinsSemiBold18,
                          ),
                        ),
                        _spacer16(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: LayoutBuilder(builder: (context, constraints) {
                            if (constraints.maxWidth < 600) {
                              return ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 16,
                                ),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    offersController.shoppingOffers.length > 4
                                        ? 4
                                        : offersController
                                            .shoppingOffers.length,
                                itemBuilder: ((context, index) => index == 3
                                    ? TextButton(
                                        onPressed: () {
                                          Get.to(() => const OffersFilterScreen(
                                              filterName: 'Shopping'));
                                        },
                                        child: const Text('Show more'))
                                    : GiftCardItem(
                                        onClick: () => Get.to(() =>
                                            RedeemCouponScreen(
                                              redemptionProcess:
                                                  offersController
                                                          .shoppingOffers[index]
                                                          .offerDetails!
                                                          .redemptionProcess ??
                                                      '',
                                              escalationMatrix: offersController
                                                      .shoppingOffers[index]
                                                      .offerDetails!
                                                      .escalationMatrix ??
                                                  '',
                                              terms: offersController
                                                      .shoppingOffers[index]
                                                      .offerDetails!
                                                      .termAndCondition ??
                                                  '',
                                              code: offersController
                                                      .shoppingOffers[index]
                                                      .code ??
                                                  '',
                                              brandLogo: offersController
                                                      .shoppingOffers[index]
                                                      .offerDetails!
                                                      .logoImageLink ??
                                                  '',
                                              description: offersController
                                                      .shoppingOffers[index]
                                                      .offerDetails!
                                                      .description ??
                                                  '',
                                            )),
                                        description: offersController
                                                .shoppingOffers[index]
                                                .offerDetails!
                                                .description ??
                                            '',
                                        expiry: offersController
                                                .shoppingOffers[index]
                                                .offerDetails!
                                                .endDateTime ??
                                            '',
                                        brandImage: offersController
                                                .shoppingOffers[index]
                                                .offerDetails!
                                                .imageLink ??
                                            '',
                                        brandLogoLink: offersController
                                                .shoppingOffers[index]
                                                .offerDetails!
                                                .logoImageLink ??
                                            offersController
                                                .shoppingOffers[index]
                                                .offerDetails!
                                                .mobileImageLink ??
                                            '',
                                        brandName: offersController
                                                .shoppingOffers[index].title ??
                                            '',
                                      )),
                              );
                            } else {
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 2,
                                        mainAxisSpacing: 16,
                                        crossAxisSpacing: 16),
                                itemCount:
                                    offersController.shoppingOffers.length > 6
                                        ? 6
                                        : offersController
                                            .shoppingOffers.length,
                                itemBuilder: ((context, index) => index == 5
                                    ? TextButton(
                                        onPressed: () {
                                          Get.to(() => const OffersFilterScreen(
                                              filterName: 'Shopping'));
                                        },
                                        child: const Text('Show more'))
                                    : GiftCardItem(
                                        onClick: () => Get.to(() =>
                                            RedeemCouponScreen(
                                              redemptionProcess:
                                                  offersController
                                                          .shoppingOffers[index]
                                                          .offerDetails!
                                                          .redemptionProcess ??
                                                      '',
                                              escalationMatrix: offersController
                                                      .shoppingOffers[index]
                                                      .offerDetails!
                                                      .escalationMatrix ??
                                                  '',
                                              terms: offersController
                                                      .shoppingOffers[index]
                                                      .offerDetails!
                                                      .termAndCondition ??
                                                  '',
                                              code: offersController
                                                      .shoppingOffers[index]
                                                      .code ??
                                                  '',
                                              brandLogo: offersController
                                                  .shoppingOffers[index]
                                                  .offerDetails!
                                                  .logoImageLink,
                                              description: offersController
                                                      .shoppingOffers[index]
                                                      .offerDetails!
                                                      .description ??
                                                  '',
                                            )),
                                        description: offersController
                                                .shoppingOffers[index]
                                                .offerDetails!
                                                .description ??
                                            '',
                                        expiry: offersController
                                                .shoppingOffers[index]
                                                .offerDetails!
                                                .endDateTime ??
                                            '',
                                        brandImage: offersController
                                            .shoppingOffers[index]
                                            .offerDetails!
                                            .imageLink,
                                        brandLogoLink: offersController
                                                .shoppingOffers[index]
                                                .offerDetails!
                                                .logoImageLink ??
                                            offersController
                                                .shoppingOffers[index]
                                                .offerDetails!
                                                .mobileImageLink,
                                        brandName: offersController
                                                .shoppingOffers[index].title ??
                                            '',
                                      )),
                              );
                            }
                          }),
                        ),
                        _spacer16(),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Top offers on electronics',
                            style: poppinsSemiBold18,
                          ),
                        ),
                        _spacer16(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: LayoutBuilder(builder: (context, constraints) {
                            if (constraints.maxWidth < 600) {
                              return ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 16,
                                ),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: offersController
                                            .electronicsOffers.length >
                                        4
                                    ? 4
                                    : offersController.electronicsOffers.length,
                                itemBuilder: ((context, index) => index == 3
                                    ? TextButton(
                                        onPressed: () {
                                          Get.to(() => const OffersFilterScreen(
                                              filterName: 'Electronics'));
                                        },
                                        child: const Text('Show more'))
                                    : GiftCardItem(
                                        onClick: () => Get.to(() =>
                                            RedeemCouponScreen(
                                              redemptionProcess:
                                                  offersController
                                                          .electronicsOffers[
                                                              index]
                                                          .offerDetails!
                                                          .redemptionProcess ??
                                                      '',
                                              escalationMatrix: offersController
                                                      .electronicsOffers[index]
                                                      .offerDetails!
                                                      .escalationMatrix ??
                                                  '',
                                              terms: offersController
                                                      .electronicsOffers[index]
                                                      .offerDetails!
                                                      .termAndCondition ??
                                                  '',
                                              code: offersController
                                                      .electronicsOffers[index]
                                                      .code ??
                                                  '',
                                              brandLogo: offersController
                                                      .electronicsOffers[index]
                                                      .offerDetails!
                                                      .logoImageLink ??
                                                  '',
                                              description: offersController
                                                      .electronicsOffers[index]
                                                      .offerDetails!
                                                      .description ??
                                                  '',
                                            )),
                                        description: offersController
                                                .electronicsOffers[index]
                                                .offerDetails!
                                                .description ??
                                            '',
                                        expiry: offersController
                                                .electronicsOffers[index]
                                                .offerDetails!
                                                .endDateTime ??
                                            '',
                                        brandImage: offersController
                                                .electronicsOffers[index]
                                                .offerDetails!
                                                .imageLink ??
                                            '',
                                        brandLogoLink: offersController
                                                .electronicsOffers[index]
                                                .offerDetails!
                                                .logoImageLink ??
                                            offersController
                                                .electronicsOffers[index]
                                                .offerDetails!
                                                .mobileImageLink ??
                                            '',
                                        brandName: offersController
                                                .electronicsOffers[index]
                                                .title ??
                                            '',
                                      )),
                              );
                            } else {
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 2,
                                        mainAxisSpacing: 16,
                                        crossAxisSpacing: 16),
                                itemCount: offersController
                                            .electronicsOffers.length >
                                        6
                                    ? 6
                                    : offersController.electronicsOffers.length,
                                itemBuilder: ((context, index) => index == 5
                                    ? TextButton(
                                        onPressed: () {
                                          Get.to(() => const OffersFilterScreen(
                                              filterName: 'Electronics'));
                                        },
                                        child: const Text('Show more'))
                                    : GiftCardItem(
                                        onClick: () => Get.to(() =>
                                            RedeemCouponScreen(
                                              redemptionProcess:
                                                  offersController
                                                          .electronicsOffers[
                                                              index]
                                                          .offerDetails!
                                                          .redemptionProcess ??
                                                      '',
                                              escalationMatrix: offersController
                                                      .electronicsOffers[index]
                                                      .offerDetails!
                                                      .escalationMatrix ??
                                                  '',
                                              terms: offersController
                                                      .electronicsOffers[index]
                                                      .offerDetails!
                                                      .termAndCondition ??
                                                  '',
                                              code: offersController
                                                      .electronicsOffers[index]
                                                      .code ??
                                                  '',
                                              brandLogo: offersController
                                                  .electronicsOffers[index]
                                                  .offerDetails!
                                                  .logoImageLink,
                                              description: offersController
                                                      .electronicsOffers[index]
                                                      .offerDetails!
                                                      .description ??
                                                  '',
                                            )),
                                        description: offersController
                                                .electronicsOffers[index]
                                                .offerDetails!
                                                .description ??
                                            '',
                                        expiry: offersController
                                                .electronicsOffers[index]
                                                .offerDetails!
                                                .endDateTime ??
                                            '',
                                        brandImage: offersController
                                            .electronicsOffers[index]
                                            .offerDetails!
                                            .imageLink,
                                        brandLogoLink: offersController
                                                .electronicsOffers[index]
                                                .offerDetails!
                                                .logoImageLink ??
                                            offersController
                                                .electronicsOffers[index]
                                                .offerDetails!
                                                .mobileImageLink,
                                        brandName: offersController
                                                .electronicsOffers[index]
                                                .title ??
                                            '',
                                      )),
                              );
                            }
                          }),
                        ),
                      ],
                    ),
                  ),
                )
              ]);
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Some error occured'),
              );
            }
            return const Center(
              child: Text('None'),
            );
          })),
    );
  }

  _spacer16() {
    return const SizedBox(
      height: 16,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
