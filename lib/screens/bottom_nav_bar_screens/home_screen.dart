import 'package:bachat_cards/Constants/constants.dart';
import 'package:bachat_cards/controllers/cards_controller.dart';
import 'package:bachat_cards/controllers/home_screen_controller.dart';
import 'package:bachat_cards/controllers/offers_screen_controller.dart';
import 'package:bachat_cards/controllers/post_login_screen_controller.dart';
import 'package:bachat_cards/screens/card_screens/add_money_screen.dart';
import 'package:bachat_cards/screens/card_screens/kyc_screen.dart';
import 'package:bachat_cards/screens/card_screens/web_view.dart';
import 'package:bachat_cards/sevrices/remote_config_service.dart';
import 'package:bachat_cards/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../sevrices/shared_prefs.dart';
import '../../wdigets/gift_card_item_widget.dart';
import '../../wdigets/kyc_widget.dart';
import '../../wdigets/no_card_widget.dart';
import '../../wdigets/card_widget.dart';
import '../offers_screens/redeem_coupon_screen.dart';
import '../temporary_paytm.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  final homeScreenController = Get.find<HomeScreenController>();
  final offersController = Get.find<OffersController>();
  final cardsController = Get.find<CardsController>();
  late TabController tabController;

  RxString kycCompleted = "none".obs;
  final RemoteConfigService service = RemoteConfigService.getInstance();
  final Dio dio = Dio(BaseOptions(
      headers: {'Authorization': 'Bearer ${SharedPrefs.getToken()}'}));

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      homeScreenController.currentCard.value = 1;
    });
    getKyc();
    service.initialise();
    super.initState();
  }

  void getKyc() async {
    await homeScreenController.getKycStatus(dio);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: Future.wait([
        cardsController.getUserCards(dio),
        offersController.getOffers(dio),
        Get.find<PostLoginScreenController>().getUserinfo(dio),
        homeScreenController.getUserBalance(dio),
      ]),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          return RefreshIndicator(
            onRefresh: () async {
              homeScreenController.currentCard.value = 1;
              homeScreenController.isLoading.value = true;
              await cardsController.getUserCards(dio);
              await homeScreenController.getKycStatus(dio);
              homeScreenController.isLoading.value = false;
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (service.getImages.images != null &&
                        service.getImages.images!.isNotEmpty)
                      LayoutBuilder(builder: (context, constraints) {
                        return SizedBox(
                          height: constraints.maxWidth > 600
                              ? MediaQuery.of(context).size.height / 4
                              : MediaQuery.of(context).size.height / 6,
                          child: PageView.builder(
                            controller: homeScreenController.carouselController,
                            padEnds: false,
                            onPageChanged: (value) {
                              homeScreenController.carouselIndex.value = value;
                            },
                            scrollDirection: Axis.horizontal,
                            itemCount: service.getImages.images?.length,
                            itemBuilder: (context, index) {
                              return CachedNetworkImage(
                                  placeholder: (context, url) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                  errorWidget: (context, url, error) {
                                    return SvgPicture.asset(
                                        'assets/images/errorImage.svg');
                                  },
                                  imageUrl: service
                                      .getImages.images![index].imageUrl!);
                            },
                          ),
                        );
                      }),
                    if (service.getImages.images != null)
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            service.getImages.images!.length,
                            (index) => Obx(
                              () => Container(
                                height: 8,
                                width: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: homeScreenController
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
                    const Padding(
                      padding: EdgeInsets.only(left: 32),
                      child: Text(
                        'My Cards',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: primaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 24),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    if (homeScreenController.isLoading.value)
                      Center(
                        child: SizedBox(
                            height: 260,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                CircularProgressIndicator(),
                              ],
                            )),
                      ),
                    if (!homeScreenController.isLoading.value)
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: primaryColor)),
                          child: TabBar(
                              padding: EdgeInsets.zero,
                              isScrollable: true,
                              unselectedLabelColor: Colors.black,
                              labelColor: Colors.white,
                              controller: tabController,
                              indicator: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(8)),
                              tabs: const [
                                Tab(
                                  child: Text(
                                    'Once-loadable',
                                  ),
                                ),
                                Tab(
                                  child: Text('Multi-loadable'),
                                )
                              ]),
                        ),
                      ),
                    if (!homeScreenController.isLoading.value)
                      const SizedBox(
                        height: 16,
                      ),
                    if (!homeScreenController.isLoading.value)
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 3.5 > 350
                            ? MediaQuery.of(context).size.height / 3.5
                            : 350,
                        child: TabBarView(
                            controller: tabController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              if (cardsController.onceLoadableCards.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: FittedBox(
                                    child: LayoutBuilder(
                                      builder: (context, constraints) =>
                                          SizedBox(
                                        height: 260,
                                        width: constraints.maxWidth > 600
                                            ? 400
                                            : null,
                                        child: NoCardWidget(
                                          onClick: () {
                                            Get.to(() => const AddMoneyScreen(
                                                type: CardType.onceReload));
                                          },
                                          cardText:
                                              'Hurry and get your once loadable card now.',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (cardsController.onceLoadableCards.isNotEmpty)
                                LayoutBuilder(builder: (context, constratins) {
                                  if (constratins.maxWidth > 600) {
                                    homeScreenController.cardsPageController =
                                        PageController(viewportFraction: 0.2);
                                  } else {
                                    homeScreenController.cardsPageController =
                                        PageController(viewportFraction: 0.45);
                                  }
                                  return OnceLoadableCardWidget(
                                      dio: dio,
                                      cardsController: cardsController,
                                      homeScreenController:
                                          homeScreenController);
                                }),
                              if (cardsController.multiLoadableCard.value
                                      .cardReferenceNumber ==
                                  null)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: FittedBox(
                                    child: LayoutBuilder(
                                      builder: (context, constraints) =>
                                          SizedBox(
                                        height: 260,
                                        width: constraints.maxWidth > 600
                                            ? 400
                                            : null,
                                        child: homeScreenController
                                                    .kycList.isNotEmpty &&
                                                homeScreenController.kycList[0]
                                                        .kycCompleted !=
                                                    "none"
                                            ? KycWidget(
                                                buttonText: "Get Card",
                                                cardText:
                                                    "Click button below to get your card",
                                                onClick: () {
                                                  Get.to(() =>
                                                      const AddMoneyScreen(
                                                          type: CardType
                                                              .multiReload));
                                                },
                                              )
                                            : homeScreenController
                                                        .kycList.isNotEmpty &&
                                                    homeScreenController
                                                            .kycList[0]
                                                            .kycCompleted ==
                                                        "none" &&
                                                    homeScreenController
                                                        .kycList[0].paid!
                                                ? KycWidget(
                                                    buttonText: "Initiate KYC",
                                                    cardText:
                                                        "Please complete your KYC",
                                                    onClick: () async {
                                                      if (Get.find<
                                                                  HomeScreenController>()
                                                              .kycList[0]
                                                              .link !=
                                                          null) {
                                                        final uri = Uri.parse(
                                                            Get.find<
                                                                    HomeScreenController>()
                                                                .kycList[0]
                                                                .link!);
                                                        if (await canLaunchUrl(
                                                            uri)) {
                                                          await launchUrl(uri,
                                                              mode: LaunchMode
                                                                  .externalApplication);
                                                        } else {
                                                          Get.snackbar('Error',
                                                              'Could not launch external browser');
                                                        }
                                                      } else {
                                                        Get.to(() =>
                                                            const KYCScreen());
                                                      }
                                                    },
                                                  )
                                                : NoCardWidget(
                                                    onClick: () {
                                                      Get.to(() =>
                                                          const KYCScreen());
                                                    },
                                                    cardText:
                                                        'Hurry and get your multi loadable card now',
                                                  ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (cardsController.multiLoadableCard.value
                                      .cardReferenceNumber !=
                                  null)
                                MultiLoadableCardWidget(
                                    homeScreenController: homeScreenController,
                                    dio: dio,
                                    cardsController: cardsController)
                            ]),
                      ),
                    if (!homeScreenController.isLoading.value &&
                        cardsController.cardsList.isEmpty)
                      const SizedBox(
                        height: 40,
                      ),
                    if (!homeScreenController.isLoading.value &&
                        cardsController.cardsList.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(left: 32),
                        child: Text(
                          'Benefits',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 24),
                        ),
                      ),
                    if (!homeScreenController.isLoading.value &&
                        cardsController.cardsList.isEmpty)
                      const SizedBox(
                        height: 16,
                      ),
                    if (!homeScreenController.isLoading.value &&
                        cardsController.cardsList.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: LayoutBuilder(builder: (context, constraints) {
                          if (constraints.maxWidth > 600) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Image.asset(
                                          'assets/images/home_cashback_1.png',
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      const Expanded(
                                        child: Text(
                                          'Get 1% instant cashback on every purchase',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: Color(0xff263238)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Image.asset(
                                            'assets/images/home_cashback_2.png'),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      const Expanded(
                                        child: Text(
                                          'Use reward points to buy discounted gift cards.',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: Color(0xff263238)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Image.asset(
                                      'assets/images/home_cashback_1.png',
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  const Expanded(
                                    child: Text(
                                      'Get 1% instant cashback on every purchase',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Color(0xff263238)),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Image.asset(
                                        'assets/images/home_cashback_2.png'),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  const Expanded(
                                    child: Text(
                                      'Use reward points to buy discounted gift cards.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Color(0xff263238)),
                                    ),
                                  )
                                ],
                              )
                            ],
                          );
                        }),
                      ),
                    if (!homeScreenController.isLoading.value &&
                        cardsController.cardsList.isEmpty)
                      const SizedBox(
                        height: 30,
                      ),
                    if (!homeScreenController.isLoading.value &&
                        cardsController.cardsList.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(left: 32),
                        child: Text(
                          'How to use cards',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 24),
                        ),
                      ),
                    if (!homeScreenController.isLoading.value &&
                        cardsController.cardsList.isEmpty)
                      const SizedBox(
                        height: 16,
                      ),
                    if (!homeScreenController.isLoading.value &&
                        cardsController.cardsList.isEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: YoutubePlayer(
                            controller: homeScreenController.youtubeController,
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 32),
                      child: Text(
                        'Exclusive Offers',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: primaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 24),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: LayoutBuilder(builder: (context, constraints) {
                        if (constraints.maxWidth < 600) {
                          return OffersWidget(
                              offersController: offersController);
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
                            itemCount: offersController.offers.length > 6
                                ? 6
                                : offersController.offers.length,
                            itemBuilder: ((context, index) => index == 5
                                ? TextButton(
                                    onPressed: () {
                                      Get.find<PostLoginScreenController>()
                                          .updateIndex(2);
                                    },
                                    child: const Text('Go to Offers'))
                                : GiftCardItem(
                                    onClick: () =>
                                        Get.to(() => RedeemCouponScreen(
                                              redemptionProcess:
                                                  offersController
                                                          .offers[index]
                                                          .offerDetails!
                                                          .redemptionProcess ??
                                                      '',
                                              escalationMatrix: offersController
                                                      .offers[index]
                                                      .offerDetails!
                                                      .escalationMatrix ??
                                                  '',
                                              terms: offersController
                                                      .offers[index]
                                                      .offerDetails!
                                                      .termAndCondition ??
                                                  '',
                                              code: offersController
                                                      .offers[index].code ??
                                                  '',
                                              brandLogo: offersController
                                                  .offers[index]
                                                  .offerDetails!
                                                  .logoImageLink,
                                              description: offersController
                                                      .offers[index]
                                                      .offerDetails!
                                                      .description ??
                                                  '',
                                            )),
                                    description: offersController.offers[index]
                                            .offerDetails!.description ??
                                        '',
                                    expiry: offersController.offers[index]
                                            .offerDetails!.endDateTime ??
                                        '',
                                    brandImage: offersController
                                        .offers[index].offerDetails!.imageLink,
                                    brandLogoLink: offersController
                                            .offers[index]
                                            .offerDetails!
                                            .logoImageLink ??
                                        offersController.offers[index]
                                            .offerDetails!.mobileImageLink,
                                    brandName:
                                        offersController.offers[index].title ??
                                            '',
                                  )),
                          );
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return const Center(
            child: Text('Some error occured'),
          );
        }
        return const Center(
          child: Text('None'),
        );
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MultiLoadableCardWidget extends StatelessWidget {
  MultiLoadableCardWidget(
      {Key? key,
      required this.cardsController,
      required this.dio,
      required this.homeScreenController})
      : super(key: key);

  final CardsController cardsController;
  final Dio dio;
  final HomeScreenController homeScreenController;
  RxBool isLoading = false.obs;

  Future<void> initiateKyc() async {
    isLoading.value = true;
    try {
      final response =
          await dio.post('${Constants.url}/mbc/v1/card/initiateKyc', data: {
        'phoneNumber': SharedPrefs.getPhoneNumber().substring(3),
      });
      if (response.data['alreadyDone'] != null) {
        Get.snackbar('Info',
            "The ${response.data['alreadyDone']} KYC for this mobile number has already been done");
      }
      if (response.data['link'] != null) {
        final uri = Uri.parse(response.data['link']);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          Get.snackbar('Error', 'Could not launch external browser');
        }
      } else if (response.data['orderId'] != null) {
        Get.to(() => TempPaytm(
            orderId: response.data['orderId'],
            amount: "24",
            kycType: KYCType.max,
            type: "kyc"));
      }
    } on DioError catch (e) {
      debugPrint(e.response.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                children: [
                  CardWidget(
                      cardsController: cardsController,
                      cardType: CardType.multiReload,
                      maskedCardNumber: cardsController
                              .multiLoadableCard.value.maskedCardNumber ??
                          '',
                      cardReferenceNumber: cardsController
                              .multiLoadableCard.value.cardReferenceNumber ??
                          '',
                      dio: dio),
                  if ((homeScreenController.kycList.isNotEmpty &&
                          homeScreenController.kycList[0].kycCompleted ==
                              "min") ||
                      homeScreenController.kycList[0].alreadyDone == "min")
                    Align(
                        alignment: Alignment.bottomRight,
                        child: Obx(
                          () => TextButton(
                              style: TextButton.styleFrom(
                                  fixedSize: const Size(140, 30)),
                              onPressed: isLoading.value
                                  ? null
                                  : () {
                                      initiateKyc();
                                    },
                              child: isLoading.value
                                  ? const FittedBox(
                                      child: CircularProgressIndicator(
                                        color: primaryColor,
                                      ),
                                    )
                                  : const Text('Go for Max KYC')),
                        )),
                  Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Get.to(() => WebView(
                            url:
                                'https://${cardsController.multiLoadableCard.value.cardLink}')),
                        child: Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color(0xfff4f4f4)),
                          child: const Text('Tap to view details'),
                        ),
                      )),
                  if ((homeScreenController.kycList.isNotEmpty &&
                          homeScreenController.kycList[0].kycCompleted ==
                              "min") ||
                      homeScreenController.kycList[0].alreadyDone == "min")
                    Positioned(
                        right: 0,
                        top: 20,
                        child: RichText(
                          text: TextSpan(
                              text: "KYC Status: ",
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                              children: [
                                TextSpan(
                                    text: Get.find<HomeScreenController>()
                                                .kycList[0]
                                                .kycCompleted ==
                                            "min"
                                        ? "Min KYC"
                                        : "Max KYC",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green))
                              ]),
                        )),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Center(
            child: GestureDetector(
              onTap: () => Get.to(() =>
                  const AddMoneyScreen(type: CardType.multiReloadAddAmount)),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xff6E56FF), Color(0xff3012E8)]),
                ),
                child: const Text(
                  'Add balance',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OnceLoadableCardWidget extends StatelessWidget {
  const OnceLoadableCardWidget(
      {Key? key,
      required this.cardsController,
      required this.dio,
      required this.homeScreenController})
      : super(key: key);

  final CardsController cardsController;
  final HomeScreenController homeScreenController;
  final Dio dio;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
              onPageChanged: (value) =>
                  homeScreenController.currentCard.value = value + 1,
              physics: const BouncingScrollPhysics(),
              controller: homeScreenController.cardsPageController,
              itemCount: cardsController.onceLoadableCards.length,
              itemBuilder: (context, index) {
                return CardWidget(
                  dio: dio,
                  cardUrl:
                      cardsController.onceLoadableCards[index].cardLink ?? '',
                  cardsController: cardsController,
                  maskedCardNumber: cardsController
                          .onceLoadableCards[index].maskedCardNumber ??
                      '',
                  cardReferenceNumber: cardsController
                          .onceLoadableCards[index].cardReferenceNumber ??
                      '',
                );
              }),
        ),
        Center(
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(
              onPressed: () {
                homeScreenController.cardsPageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.fastLinearToSlowEaseIn);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            Obx(
              () => Text(
                '${homeScreenController.currentCard.value} / ${cardsController.onceLoadableCards.length}',
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ),
            IconButton(
              onPressed: () {
                homeScreenController.cardsPageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.fastLinearToSlowEaseIn);
              },
              icon: const Icon(Icons.arrow_forward),
            ),
          ]),
        ),
        Center(
          child: GestureDetector(
            onTap: () =>
                Get.to(() => const AddMoneyScreen(type: CardType.onceReload)),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xff6E56FF), Color(0xff3012E8)]),
              ),
              child: const Text(
                'Get more',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class OffersWidget extends StatelessWidget {
  const OffersWidget({
    Key? key,
    required this.offersController,
  }) : super(key: key);

  final OffersController offersController;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (_, __) => const SizedBox(
        height: 16,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: offersController.offers.length > 6
          ? 6
          : offersController.offers.length,
      itemBuilder: ((context, index) => index == 5
          ? TextButton(
              onPressed: () {
                Get.find<PostLoginScreenController>().updateIndex(2);
              },
              child: const Text('Go to Offers'))
          : GiftCardItem(
              onClick: () => Get.to(() => RedeemCouponScreen(
                    redemptionProcess: offersController
                            .offers[index].offerDetails!.redemptionProcess ??
                        '',
                    escalationMatrix: offersController
                            .offers[index].offerDetails!.escalationMatrix ??
                        '',
                    terms: offersController
                            .offers[index].offerDetails!.termAndCondition ??
                        '',
                    code: offersController.offers[index].code ?? '',
                    brandLogo: offersController
                        .offers[index].offerDetails!.logoImageLink,
                    description: offersController
                            .offers[index].offerDetails!.description ??
                        '',
                  )),
              description:
                  offersController.offers[index].offerDetails!.description ??
                      '',
              expiry:
                  offersController.offers[index].offerDetails!.endDateTime ??
                      '',
              brandImage:
                  offersController.offers[index].offerDetails!.imageLink,
              brandLogoLink: offersController
                      .offers[index].offerDetails!.logoImageLink ??
                  offersController.offers[index].offerDetails!.mobileImageLink,
              brandName: offersController.offers[index].title ?? '',
            )),
    );
  }
}
