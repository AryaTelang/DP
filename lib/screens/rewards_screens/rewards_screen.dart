import 'package:bachat_cards/controllers/rewards_screen_controller.dart';
import 'package:bachat_cards/models/rewards.dart';
import 'package:bachat_cards/screens/rewards_screens/all_rewards_screen.dart';
import 'package:bachat_cards/screens/rewards_screens/redeem_points_screen.dart';
import 'package:bachat_cards/screens/rewards_screens/rewards_filter_screen.dart';
import 'package:bachat_cards/screens/rewards_screens/search_rewards_screen.dart';
import 'package:bachat_cards/sevrices/firebase_analytics.dart';
import 'package:bachat_cards/theme/theme.dart';
import 'package:bachat_cards/wdigets/rewards_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../sevrices/remote_config_service.dart';
import '../../sevrices/shared_prefs.dart';
import '../../wdigets/search_widget.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen>
    with AutomaticKeepAliveClientMixin {
  final RewardsScreenController rewardsScreenController =
      Get.find<RewardsScreenController>();

  List<Widget> filterWidgetsList = [
    SvgPicture.asset(
      'assets/images/accessories.svg',
      height: 30,
    ),
    SvgPicture.asset(
      'assets/images/apparel.svg',
      height: 30,
    ),
    SvgPicture.asset(
      'assets/images/beauty.svg',
      height: 30,
    ),
    SvgPicture.asset(
      'assets/images/ecommerce.svg',
      height: 30,
    ),
    SvgPicture.asset(
      'assets/images/electronics.svg',
      height: 30,
    ),
    SvgPicture.asset(
      'assets/images/food.svg',
      height: 30,
    ),
    SvgPicture.asset(
      'assets/images/grocery.svg',
      height: 30,
    ),
    SvgPicture.asset(
      'assets/images/medicine.svg',
      height: 30,
    ),
    SvgPicture.asset(
      'assets/images/travel.svg',
      height: 30,
    ),
    const Icon(
      Icons.chevron_right_sharp,
      color: primaryColor,
      size: 30,
    )
  ];

  List<String> filterWidgetsText = [
    'Accessories',
    'Apparel',
    'Beauty',
    'E-comm',
    'Electronics',
    'Food',
    'Grocery',
    'Medicine',
    'Travel',
    'More'
  ];

  final Dio dio = Dio(BaseOptions(
      headers: {'Authorization': 'Bearer ${SharedPrefs.getToken()}'}));

  final RemoteConfigService service = RemoteConfigService.getInstance();

  @override
  void initState() {
    service.initialise();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = (MediaQuery.of(context).size.width) / 5;
    return RefreshIndicator(
      onRefresh: () => rewardsScreenController.getRewards(dio),
      child: FutureBuilder(
          future: rewardsScreenController.getRewards(dio),
          builder: ((context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Some error occured'),
              );
            }
            if (snapshot.hasData) {
              return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Get.to(() => const SearchRewardsScreen());
                        },
                        child: const SearchWidget()),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Wrap(
                              direction: Axis.horizontal,
                              children: List.generate(
                                filterWidgetsText.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    AnalyticsService.logRewardFilter(
                                        filter: filterWidgetsText[index]);
                                    Get.to(() => FilterRewardsScreen(
                                          filterName: index ==
                                                  filterWidgetsList.length - 1
                                              ? 'Others'
                                              : filterWidgetsText[index],
                                        ));
                                  },
                                  child: SizedBox(
                                    width: size,
                                    child: Card(
                                      elevation: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          runAlignment: WrapAlignment.center,
                                          direction: Axis.vertical,
                                          children: [
                                            CircleAvatar(
                                                radius: 20,
                                                backgroundColor:
                                                    const Color(0xfff6f6f6),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child:
                                                      filterWidgetsList[index],
                                                )),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              filterWidgetsText[index],
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            if (rewardsScreenController
                                .carouselImages.isNotEmpty)
                              LayoutBuilder(builder: (context, constraints) {
                                return SizedBox(
                                  height: constraints.maxWidth > 600
                                      ? MediaQuery.of(context).size.height / 4
                                      : MediaQuery.of(context).size.height / 6,
                                  child: PageView.builder(
                                    controller: rewardsScreenController
                                        .carouselController,
                                    padEnds: false,
                                    onPageChanged: (value) {
                                      rewardsScreenController
                                          .carouselIndex.value = value;
                                    },
                                    scrollDirection: Axis.horizontal,
                                    itemCount: rewardsScreenController
                                        .carouselImages.length,
                                    itemBuilder: (context, index) {
                                      return CachedNetworkImage(
                                          placeholder: (context, url) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          },
                                          errorWidget: (context, url, error) {
                                            return SvgPicture.asset(
                                                'assets/images/errorImage.svg');
                                          },
                                          imageUrl: rewardsScreenController
                                                  .carouselImages[index]
                                                  .image ??
                                              '');
                                    },
                                  ),
                                );
                              }),
                            if (rewardsScreenController.carouselImages.isNotEmpty)
                              Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                    rewardsScreenController.carouselImages.length,
                                    (index) => Obx(
                                      () => Container(
                                        height: 8,
                                        width: 8,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: rewardsScreenController
                                                      .carouselIndex.value ==
                                                  index
                                              ? secondaryColor
                                              : Colors.grey,
                                        ),
                                        margin: const EdgeInsets.all(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      rewardsScreenController.rewards.length,
                                  itemBuilder: ((context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Text(
                                              rewardsScreenController
                                                      .rewards[index].title ??
                                                  '',
                                              style: poppinsBold20,
                                            ),
                                          ),
                                          LayoutBuilder(
                                            builder: (context, constraints) =>
                                                GridView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount:
                                                                constraints.maxWidth >
                                                                        600
                                                                    ? 3
                                                                    : 2,
                                                            childAspectRatio:
                                                                0.65,
                                                            mainAxisSpacing: 8,
                                                            crossAxisSpacing:
                                                                16),
                                                    itemCount:
                                                        rewardsScreenController
                                                                    .rewards[
                                                                        index]
                                                                    .brands!
                                                                    .length >
                                                                6
                                                            ? 6
                                                            : rewardsScreenController
                                                                .rewards[index]
                                                                .brands!
                                                                .length,
                                                    itemBuilder: ((context, i) {
                                                      final Brands brand =
                                                          rewardsScreenController
                                                              .rewards[index]
                                                              .brands![i];
                                                      if (i == 5) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            Get.to(() => AllRewardsScreen(
                                                                dealName: rewardsScreenController
                                                                        .rewards[
                                                                            index]
                                                                        .title ??
                                                                    ''));
                                                          },
                                                          child: Card(
                                                            elevation: 5,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16)),
                                                            child: const Center(
                                                              child: Text(
                                                                'View All',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        String brandImage = '';
                                                        if (brand.gyftrImage !=
                                                            '') {
                                                          brandImage =
                                                              brand.gyftrImage!;
                                                        } else {
                                                          brandImage = brand
                                                              .pineImage!
                                                              .mobile!;
                                                        }
                                                        return GestureDetector(
                                                          onTap: () => Get.to(() =>
                                                              RedeemPointsScreen(
                                                                brandId:
                                                                    brand.sId ??
                                                                        '',
                                                              )),
                                                          child: RewardsItem(
                                                            brandName:
                                                                brand.name ??
                                                                    '',
                                                            brandLogoLink:
                                                                brandImage,
                                                            imageLink: brand
                                                                .brandImages![0],
                                                            discountPercentage:
                                                                brand.discountOthers ??
                                                                    0,
                                                          ),
                                                        );
                                                      }
                                                    })),
                                          )
                                        ],
                                      ),
                                    );
                                  })),
                            )
                          ],
                        ),
                      ),
                    )
                  ]);
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          })),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
