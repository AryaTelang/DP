import 'package:bachat_cards/Constants/constants.dart';
import 'package:bachat_cards/appbar/appbar.dart';
import 'package:bachat_cards/controllers/cards_controller.dart';
import 'package:bachat_cards/screens/card_screens/kyc_screen.dart';
import 'package:bachat_cards/screens/card_screens/web_view.dart';
import 'package:bachat_cards/theme/theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../controllers/home_screen_controller.dart';
import '../../controllers/view_cards_screen_controller.dart';
import '../../sevrices/shared_prefs.dart';
import '../../wdigets/kyc_widget.dart';
import '../../wdigets/no_card_widget.dart';
import '../../wdigets/card_widget.dart';
import 'add_money_screen.dart';

class ViewCardsScreen extends StatefulWidget {
  const ViewCardsScreen({super.key});

  @override
  State<ViewCardsScreen> createState() => _ViewCardsScreenState();
}

class _ViewCardsScreenState extends State<ViewCardsScreen>
    with SingleTickerProviderStateMixin {
  final cardsController = Get.find<CardsController>();
  final viewCardsScreenController = Get.put(ViewCardsScreenController());
  late TabController tabController;
  final Dio dio = Dio(BaseOptions(
      headers: {'Authorization': 'Bearer ${SharedPrefs.getToken()}'}));

  @override
  void initState() {
    if (cardsController.onceLoadableCards.isNotEmpty) {
      viewCardsScreenController.getTransactions(
          cardsController.onceLoadableCards[0].cardReferenceNumber ?? '', dio);
    }
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      viewCardsScreenController.currentCard.value = 1;
      if (tabController.indexIsChanging &&
          tabController.index == 0 &&
          cardsController.onceLoadableCards.isNotEmpty) {
        viewCardsScreenController.getTransactions(
            cardsController.onceLoadableCards[0].cardReferenceNumber ?? '',
            dio);
      } else if (tabController.indexIsChanging &&
          tabController.index == 1 &&
          cardsController.multiLoadableCard.value.cardReferenceNumber != null) {
        viewCardsScreenController.getTransactions(
            cardsController.multiLoadableCard.value.cardReferenceNumber ?? '',
            dio);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SharedAppBar(
          appBar: AppBar(),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'My Cards',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: textColor),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
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
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 3.5 > 350
                    ? MediaQuery.of(context).size.height / 3.5
                    : 350,
                child: TabBarView(
                    controller: tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      if (cardsController.onceLoadableCards.isEmpty)
                        FittedBox(
                          child: LayoutBuilder(
                            builder: (context, constraints) => SizedBox(
                              height: 260,
                              width: constraints.maxWidth > 600 ? 400 : null,
                              child: NoCardWidget(
                                  onClick: () => Get.to(() =>
                                      const AddMoneyScreen(
                                          type: CardType.onceReload)),
                                  cardText:
                                      'Hurry and get your once loadable card now'),
                            ),
                          ),
                        ),
                      if (cardsController.onceLoadableCards.isNotEmpty)
                        LayoutBuilder(builder: (context, constraints) {
                          if (constraints.maxWidth > 600) {
                            viewCardsScreenController.cardsPageController =
                                PageController(viewportFraction: 0.2);
                          } else {
                            viewCardsScreenController.cardsPageController =
                                PageController(viewportFraction: 0.5);
                          }
                          return OnceLoadableCardWidget(
                            cardsController: cardsController,
                            homeScreenController: viewCardsScreenController,
                            dio: dio,
                          );
                        }),
                      if (cardsController
                              .multiLoadableCard.value.cardReferenceNumber ==
                          null)
                        FittedBox(
                          child: LayoutBuilder(
                            builder: (context, constraints) => SizedBox(
                              height: 260,
                              width: constraints.maxWidth > 600 ? 400 : null,
                              child:
                                  Get.find<HomeScreenController>()
                                              .kycList
                                              .isNotEmpty &&
                                          Get.find<HomeScreenController>()
                                                  .kycList[0]
                                                  .kycCompleted !=
                                              "none"
                                      ? KycWidget(
                                          buttonText: "Get Card",
                                          cardText:
                                              "Click button below to get your card",
                                          onClick: () {
                                            Get.to(() => const AddMoneyScreen(
                                                type: CardType.multiReload));
                                          },
                                        )
                                      : Get.find<HomeScreenController>()
                                                  .kycList
                                                  .isNotEmpty &&
                                              Get.find<HomeScreenController>()
                                                      .kycList[0]
                                                      .kycCompleted ==
                                                  "none" &&
                                              Get.find<HomeScreenController>()
                                                  .kycList[0]
                                                  .paid!
                                          ? KycWidget(
                                              buttonText: "Initiate KYC",
                                              cardText:
                                                  "Please complete your KYC",
                                              onClick: () {
                                                Get.find<HomeScreenController>()
                                                            .kycList[0]
                                                            .link ==
                                                        null
                                                    ? Get.to(
                                                        () => const KYCScreen())
                                                    : Get.to(() => WebView(
                                                        url: Get.find<
                                                                    HomeScreenController>()
                                                                .kycList[0]
                                                                .link ??
                                                            ''));
                                              },
                                            )
                                          : NoCardWidget(
                                              onClick: () {
                                                Get.to(() => const KYCScreen());
                                              },
                                              cardText:
                                                  'Hurry and get your multi loadable card now',
                                            ),
                            ),
                          ),
                        ),
                      if (cardsController
                              .multiLoadableCard.value.cardReferenceNumber !=
                          null)
                        MultiLoadableCardWidget(
                            dio: dio, cardsController: cardsController)
                    ]),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Transactions',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: textColor),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Obx(() {
              if (!viewCardsScreenController.isLoading.value &&
                  viewCardsScreenController.transactions.isEmpty) {
                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => viewCardsScreenController.getTransactions(
                        viewCardsScreenController.selectedCardType.value ==
                                SelectedCardType.onceLoadable
                            ? cardsController
                                    .onceLoadableCards[viewCardsScreenController
                                            .currentCard.value -
                                        1]
                                    .cardReferenceNumber ??
                                ''
                            : cardsController.multiLoadableCard.value
                                    .cardReferenceNumber ??
                                '',
                        dio),
                    child: ListView(
                      children: const [
                        Center(
                          child: Text('No transactions available'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Container();
            }),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: RefreshIndicator(
                  onRefresh: () => viewCardsScreenController.getTransactions(
                      viewCardsScreenController.selectedCardType.value ==
                              SelectedCardType.onceLoadable
                          ? cardsController
                                  .onceLoadableCards[viewCardsScreenController
                                          .currentCard.value -
                                      1]
                                  .cardReferenceNumber ??
                              ''
                          : cardsController.multiLoadableCard.value
                                  .cardReferenceNumber ??
                              '',
                      dio),
                  child: Obx(
                    () => ListView.builder(
                        itemCount: viewCardsScreenController.isLoading.value
                            ? 20
                            : viewCardsScreenController.transactions.length,
                        itemBuilder: (context, index) {
                          if (viewCardsScreenController.isLoading.value) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(16)),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                              ),
                            );
                          }
                          if (viewCardsScreenController.isLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return TransactionWidget(
                            viewCardsScreenController:
                                viewCardsScreenController,
                            index: index,
                          );
                        }),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}

class TransactionWidget extends StatelessWidget {
  const TransactionWidget(
      {super.key,
      required this.viewCardsScreenController,
      required this.index});

  final ViewCardsScreenController viewCardsScreenController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xfff4f4f4),
          borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              viewCardsScreenController.transactions[index].merchantName ??
                  'Merchant Name',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              DateFormat.yMMMMEEEEd().format(DateTime.parse(
                  viewCardsScreenController
                      .transactions[index].transactionDate!)),
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Color(0xffaaaaaa)),
            )
          ],
        ),
        Text(
          viewCardsScreenController.transactions[index].transactionType ==
                      TransactionType.debit.value ||
                  viewCardsScreenController
                          .transactions[index].transactionType ==
                      TransactionType.surchargeDebit.value
              ? '-\u{20B9}${viewCardsScreenController.transactions[index].transactionAmount}'
              : viewCardsScreenController.transactions[index].transactionType ==
                          TransactionType.credit.value ||
                      viewCardsScreenController
                              .transactions[index].transactionType ==
                          TransactionType.cashback.value ||
                      viewCardsScreenController
                              .transactions[index].transactionType ==
                          TransactionType.refund.value ||
                      viewCardsScreenController
                              .transactions[index].transactionType ==
                          TransactionType.reversal.value ||
                      viewCardsScreenController
                              .transactions[index].transactionType ==
                          TransactionType.surchargeReversal.value
                  ? '+\u{20B9}${viewCardsScreenController.transactions[index].transactionAmount}'
                  : '\u{20B9}${viewCardsScreenController.transactions[index].transactionAmount}',
          style: const TextStyle(
              fontWeight: FontWeight.w700, fontSize: 14, color: primaryColor),
        )
      ]),
    );
  }
}

class MultiLoadableCardWidget extends StatelessWidget {
  const MultiLoadableCardWidget(
      {Key? key, required this.cardsController, required this.dio})
      : super(key: key);

  final CardsController cardsController;
  final Dio dio;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Expanded(
            child: CardWidget(
                cardUrl: cardsController.multiLoadableCard.value.cardLink ?? '',
                cardsController: cardsController,
                cardType: CardType.multiReload,
                maskedCardNumber:
                    cardsController.multiLoadableCard.value.maskedCardNumber ??
                        '',
                cardReferenceNumber: cardsController
                        .multiLoadableCard.value.cardReferenceNumber ??
                    '',
                dio: dio),
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
          ),
        ],
      ),
    );
  }
}

class OnceLoadableCardWidget extends StatelessWidget {
  const OnceLoadableCardWidget(
      {Key? key,
      required this.cardsController,
      required this.homeScreenController,
      required this.dio})
      : super(key: key);

  final CardsController cardsController;
  final ViewCardsScreenController homeScreenController;
  final Dio dio;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
              onPageChanged: (value) {
                homeScreenController.currentCard.value = value + 1;
                homeScreenController.getTransactions(
                    cardsController
                            .onceLoadableCards[value].cardReferenceNumber ??
                        '',
                    dio);
              },
              physics: const BouncingScrollPhysics(),
              controller: homeScreenController.cardsPageController,
              itemCount: cardsController.onceLoadableCards.length,
              itemBuilder: (context, index) {
                return CardWidget(
                  cardUrl:
                      cardsController.onceLoadableCards[index].cardLink ?? '',
                  dio: dio,
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
