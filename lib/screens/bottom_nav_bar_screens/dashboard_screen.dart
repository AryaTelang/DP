import 'package:bachat_cards/Constants/constants.dart';
import 'package:bachat_cards/controllers/cards_controller.dart';
import 'package:bachat_cards/controllers/dashboard_controller.dart';
import 'package:bachat_cards/controllers/home_screen_controller.dart';
import 'package:bachat_cards/screens/card_screens/kyc_screen.dart';
import 'package:bachat_cards/screens/card_screens/kycnew.dart';
import 'package:bachat_cards/theme/theme.dart';
import 'package:bachat_cards/wdigets/no_card_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../sevrices/firebase_analytics.dart';
import '../../sevrices/shared_prefs.dart';
import '../../wdigets/card_widget.dart';
import '../../wdigets/kyc_widget.dart';
import '../card_screens/add_money_screen.dart';
import '../card_screens/kyc_details_screen.dart';
import '../card_screens/web_view.dart';
import 'home_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  final cardsController = Get.find<CardsController>();
  final dashboardController = Get.find<DashboardController>();
  final Dio dio = Dio(BaseOptions(
      headers: {'Authorization': 'Bearer ${SharedPrefs.getToken()}'}));

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    if (cardsController.onceLoadableCards.isNotEmpty) {
      dashboardController.getTransactionsForCard(
          cardsController.onceLoadableCards[0].cardReferenceNumber ?? '', dio);
    }
    if (cardsController.multiLoadableCard.value.cardReferenceNumber != null) {
      dashboardController.getTransactionsForMultiLoadableCard(
          cardsController.multiLoadableCard.value.cardReferenceNumber ?? '',
          dio);
    }
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        dashboardController.selectedCardType.value =
            SelectedCardType.onceLoadable;
      } else {
        dashboardController.selectedCardType.value =
            SelectedCardType.multiLoadable;
      }
    });
    super.initState();
  }

  var size, height, width;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff7C64FF), Color(0xff130078)])),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () => Get.to(() => const HomeScreen()),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Dashboard",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      )),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white)),
                    child: TabBar(
                        padding: EdgeInsets.zero,
                        isScrollable: true,
                        unselectedLabelColor: Colors.white,
                        labelColor: Colors.white,
                        controller: _tabController,
                        indicator: BoxDecoration(
                            color: Color(0xff2800FE),
                            borderRadius: BorderRadius.circular(8)),
                        onTap: (index) {
                          _tabController.animateTo(index);
                          setState(() {
                            _tabController.index = index;
                          }); // Trigger a rebuild to update the tab indicator
                        },
                        tabs: [
                          Tab(
                            child: Text(
                              'Gift Cards',
                              style: TextStyle(
                                  color: _tabController.index == 0
                                      ? Colors.white
                                      : Color(0xff2800fe)),
                            ),
                          ),
                          Tab(
                            child: Text('Reloadable Cards',
                                style: TextStyle(
                                    color: _tabController.index == 1
                                        ? Colors.white
                                        : Color(0xff2800fe))),
                          )
                        ]),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          offset: Offset(2, 2),
                          blurRadius: 10,
                          spreadRadius: 2)
                    ],
                    color: Colors.white),
                width: width,
                height: height * 0.8,
                child: Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TabBarView(
                          controller: _tabController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            LayoutBuilder(builder: (context, constraints) {
                              if (constraints.maxWidth > 600) {
                                dashboardController.cardsPageController =
                                    PageController(viewportFraction: 0.2);
                              } else {
                                dashboardController.cardsPageController =
                                    PageController(viewportFraction: 0.5);
                              }
                              return OnceLoadableWidget(
                                cardsController: cardsController,
                                dashboardController: dashboardController,
                                dio: dio,
                              );
                            }),
                            MultiLoadableWidget(
                              cardsController: cardsController,
                              dashboardController: dashboardController,
                              dio: dio,
                            )
                          ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class OnceLoadableWidget extends StatefulWidget {
  const OnceLoadableWidget(
      {Key? key,
      required this.cardsController,
      required this.dashboardController,
      required this.dio})
      : super(key: key);

  final CardsController cardsController;
  final DashboardController dashboardController;
  final Dio dio;
  @override
  State<OnceLoadableWidget> createState() => _OnceLoadableWidgetState();
}

class _OnceLoadableWidgetState extends State<OnceLoadableWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        await widget.cardsController.getUserCards(widget.dio);
        widget.dashboardController.selectedYear.value =
            DateTime.now().year.toString();
        widget.dashboardController.isShowMonthlyTransactions.value = false;
        widget.dashboardController.monthlyTransactions.clear();
        if (widget.cardsController.onceLoadableCards.isNotEmpty) {
          widget.dashboardController.getTransactionsForCard(
              widget
                      .cardsController
                      .onceLoadableCards[
                          widget.dashboardController.currentCard.value - 1]
                      .cardReferenceNumber ??
                  '',
              widget.dio);
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) => ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: constraints.maxHeight, minWidth: constraints.maxWidth),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.cardsController.onceLoadableCards.isEmpty)
                    Center(
                      child: LayoutBuilder(
                        builder: (context, constraints) => SizedBox(
                          height: 260,
                          width: constraints.maxWidth > 600 ? 400 : null,
                          child: NoCardWidget(
                            onClick: () => Get.to(() => const AddMoneyScreen(
                                type: CardType.onceReload)),
                            cardText: '',
                          ),
                        ),
                      ),
                    ),
                  if (widget.cardsController.onceLoadableCards.isNotEmpty)
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 3.5 > 350
                          ? MediaQuery.of(context).size.height / 3.5
                          : 350,
                      child: Column(
                        children: [
                          Expanded(
                            child: PageView.builder(
                                onPageChanged: (value) {
                                  widget.dashboardController.currentCard.value =
                                      value + 1;
                                  widget.dashboardController
                                      .isShowMonthlyTransactions.value = false;

                                  widget.dashboardController.transactions
                                      .clear();
                                  widget.dashboardController
                                      .getTransactionsForCard(
                                          widget
                                                  .cardsController
                                                  .onceLoadableCards[value]
                                                  .cardReferenceNumber ??
                                              '',
                                          widget.dio);
                                },
                                physics: const BouncingScrollPhysics(),
                                controller: widget
                                    .dashboardController.cardsPageController,
                                itemCount: widget
                                    .cardsController.onceLoadableCards.length,
                                itemBuilder: (context, index) {
                                  return CardWidget(
                                    cardUrl: widget
                                            .cardsController
                                            .onceLoadableCards[index]
                                            .cardLink ??
                                        '',
                                    dio: widget.dio,
                                    cardsController: widget.cardsController,
                                    maskedCardNumber: widget
                                            .cardsController
                                            .onceLoadableCards[index]
                                            .maskedCardNumber ??
                                        '',
                                    cardReferenceNumber: widget
                                            .cardsController
                                            .onceLoadableCards[index]
                                            .cardReferenceNumber ??
                                        '',
                                  );
                                }),
                          ),
                          Center(
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              IconButton(
                                onPressed: () {
                                  widget.dashboardController.cardsPageController
                                      .previousPage(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.fastLinearToSlowEaseIn);
                                },
                                icon: const Icon(Icons.arrow_back),
                              ),
                              Obx(
                                () => Text(
                                  '${widget.dashboardController.currentCard.value} / ${widget.cardsController.onceLoadableCards.length}',
                                  style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  widget.dashboardController.cardsPageController
                                      .nextPage(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.fastLinearToSlowEaseIn);
                                },
                                icon: const Icon(Icons.arrow_forward),
                              ),
                            ]),
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: () => Get.to(() => const AddMoneyScreen(
                                  type: CardType.onceReload)),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: const LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xff6E56FF),
                                        Color(0xff3012E8)
                                      ]),
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
                      ),
                    ),
                  if (widget.dashboardController.selectedCardType.value ==
                          SelectedCardType.onceLoadable &&
                      widget.cardsController.onceLoadableCards.isNotEmpty &&
                      widget.dashboardController.isLoading.value)
                    SizedBox(
                      height: constraints.maxHeight / 2,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  if (widget.dashboardController.selectedCardType.value ==
                          SelectedCardType.onceLoadable &&
                      widget.cardsController.onceLoadableCards.isNotEmpty &&
                      widget.dashboardController.transactions.isEmpty &&
                      !widget.dashboardController.isLoading.value)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text('You don\'t have any transactions'),
                      ),
                    ),
                  if (widget.dashboardController.transactions.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Analytics',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          GestureDetector(
                            onTap: () =>
                                _pickYear(context, widget.dashboardController),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: primaryColor),
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Obx(() => Text(
                                        'Year - ${widget.dashboardController.selectedYear}',
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      )),
                                  const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  if (widget.dashboardController.transactions.isNotEmpty)
                    SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        series: <ColumnSeries<Transactions, String>>[
                          ColumnSeries<Transactions, String>(
                              dataSource: <Transactions>[
                                Transactions(
                                    'Jan',
                                    widget.dashboardController
                                        .getMonthlyTotal('Jan')),
                                Transactions(
                                    'Feb',
                                    widget.dashboardController
                                        .getMonthlyTotal('Feb')),
                                Transactions(
                                    'Mar',
                                    widget.dashboardController
                                        .getMonthlyTotal('Mar')),
                                Transactions(
                                    'Apr',
                                    widget.dashboardController
                                        .getMonthlyTotal('Apr')),
                                Transactions(
                                    'May',
                                    widget.dashboardController
                                        .getMonthlyTotal('May')),
                                Transactions(
                                    'Jun',
                                    widget.dashboardController
                                        .getMonthlyTotal('Jun')),
                                Transactions(
                                    'Jul',
                                    widget.dashboardController
                                        .getMonthlyTotal('Jul')),
                                Transactions(
                                    'Aug',
                                    widget.dashboardController
                                        .getMonthlyTotal('Aug')),
                                Transactions(
                                    'Sep',
                                    widget.dashboardController
                                        .getMonthlyTotal('Sep')),
                                Transactions(
                                    'Oct',
                                    widget.dashboardController
                                        .getMonthlyTotal('Oct')),
                                Transactions(
                                    'Nov',
                                    widget.dashboardController
                                        .getMonthlyTotal('Nov')),
                                Transactions(
                                    'Dec',
                                    widget.dashboardController
                                        .getMonthlyTotal('Dec')),
                              ],
                              color: primaryColor.withOpacity(0.5),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4)),
                              onPointTap: (pointInteractionDetails) {
                                widget.dashboardController
                                        .isShowMonthlyTransactions.value =
                                    !widget.dashboardController
                                        .isShowMonthlyTransactions.value;
                                if (widget.dashboardController
                                    .isShowMonthlyTransactions.value) {
                                  widget.dashboardController
                                      .getMonthlyTransactions(widget
                                          .dashboardController
                                          .getMonth(pointInteractionDetails
                                                  .pointIndex ??
                                              0));
                                } else {
                                  widget.dashboardController.monthlyTransactions
                                      .clear();
                                }
                              },
                              selectionBehavior: SelectionBehavior(
                                  enable: true,
                                  selectedColor: primaryColor,
                                  toggleSelection: true),
                              xValueMapper: (Transactions sales, _) =>
                                  sales.year,
                              yValueMapper: (Transactions sales, _) =>
                                  sales.sales)
                        ]),
                  if (widget
                      .dashboardController.isShowMonthlyTransactions.value)
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Transactions',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                  if (widget
                      .dashboardController.isShowMonthlyTransactions.value)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget
                              .dashboardController.monthlyTransactions.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xfff4f4f4),
                                  borderRadius: BorderRadius.circular(16)),
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget
                                                  .dashboardController
                                                  .monthlyTransactions[index]
                                                  .merchantName ??
                                              'Merchant Name',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          DateFormat.yMMMMEEEEd().format(
                                              DateTime.parse(widget
                                                  .dashboardController
                                                  .monthlyTransactions[index]
                                                  .transactionDate!)),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color: Color(0xffaaaaaa)),
                                        )
                                      ],
                                    ),
                                    Text(
                                      widget
                                                      .dashboardController
                                                      .monthlyTransactions[
                                                          index]
                                                      .transactionType ==
                                                  TransactionType.debit.value ||
                                              widget
                                                      .dashboardController
                                                      .monthlyTransactions[
                                                          index]
                                                      .transactionType ==
                                                  TransactionType
                                                      .surchargeDebit.value
                                          ? '-\u{20B9}${widget.dashboardController.monthlyTransactions[index].transactionAmount}'
                                          : widget
                                                          .dashboardController
                                                          .monthlyTransactions[
                                                              index]
                                                          .transactionType ==
                                                      TransactionType
                                                          .credit.value ||
                                                  widget
                                                          .dashboardController
                                                          .monthlyTransactions[
                                                              index]
                                                          .transactionType ==
                                                      TransactionType
                                                          .cashback.value ||
                                                  widget
                                                          .dashboardController
                                                          .monthlyTransactions[
                                                              index]
                                                          .transactionType ==
                                                      TransactionType
                                                          .refund.value ||
                                                  widget
                                                          .dashboardController
                                                          .monthlyTransactions[
                                                              index]
                                                          .transactionType ==
                                                      TransactionType
                                                          .reversal.value ||
                                                  widget
                                                          .dashboardController
                                                          .monthlyTransactions[
                                                              index]
                                                          .transactionType ==
                                                      TransactionType
                                                          .surchargeReversal
                                                          .value
                                              ? '+\u{20B9}${widget.dashboardController.monthlyTransactions[index].transactionAmount}'
                                              : '\u{20B9}${widget.dashboardController.monthlyTransactions[index].transactionAmount}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: primaryColor),
                                    )
                                  ]),
                            );
                          }),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MultiLoadableWidget extends StatefulWidget {
  const MultiLoadableWidget(
      {Key? key,
      required this.cardsController,
      required this.dashboardController,
      required this.dio})
      : super(key: key);

  final CardsController cardsController;
  final DashboardController dashboardController;
  final Dio dio;

  @override
  State<MultiLoadableWidget> createState() => _MultiLoadableWidgetState();
}

class _MultiLoadableWidgetState extends State<MultiLoadableWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        widget.dashboardController.isLoading.value = true;
        await widget.cardsController.getUserCards(widget.dio);
        widget.dashboardController.isShowMultiLoadableCardMonthlyTransactions
            .value = false;
        widget.dashboardController.multiLoadableMonthlyTransactions.clear();
        widget.dashboardController.multiLoadableSelectedYear.value =
            DateTime.now().year.toString();
        if (widget
                .cardsController.multiLoadableCard.value.cardReferenceNumber !=
            null) {
          widget.dashboardController.multiLoadableCardYearlyTransactions
              .clear();
          widget.dashboardController.getTransactionsForMultiLoadableCard(
              widget.cardsController.multiLoadableCard.value
                      .cardReferenceNumber ??
                  '',
              widget.dio);
        }
        widget.dashboardController.isLoading.value = false;
      },
      child: LayoutBuilder(
        builder: (context, constraints) => ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: constraints.maxHeight, minWidth: constraints.maxWidth),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Obx(
              () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.cardsController.multiLoadableCard.value
                            .cardReferenceNumber ==
                        null)
                      Center(
                        child: LayoutBuilder(
                          builder: (ctx, constraints) => SizedBox(
                            height: 260,
                            width: constraints.maxWidth > 600 ? 400 : null,
                            child: Get.find<HomeScreenController>()
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
                                        cardText: "Please complete your KYC",
                                        onClick: () async {
                                          if (Get.find<HomeScreenController>()
                                                  .kycList[0]
                                                  .link !=
                                              null) {
                                            final uri = Uri.parse(
                                                Get.find<HomeScreenController>()
                                                    .kycList[0]
                                                    .link!);
                                            if (await canLaunchUrl(uri)) {
                                              await launchUrl(uri,
                                                  mode: LaunchMode
                                                      .externalApplication);
                                            } else {
                                              Get.snackbar('Error',
                                                  'Could not launch external browser');
                                            }
                                          } else {
                                            Get.to(() => const KYCNew());
                                          }
                                        },
                                      )
                                    : NoCardWidget(
                                        onClick: () {
                                          Get.to(() => const KYCNew());
                                        },
                                        cardText:
                                            'Hurry and get your multi loadable card now',
                                      ),
                          ),
                        ),
                      ),
                    if (widget.cardsController.multiLoadableCard.value
                            .cardReferenceNumber !=
                        null)
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 3.5 > 350
                            ? MediaQuery.of(context).size.height / 3.5
                            : 350,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              Expanded(
                                child: CardWidget(
                                    cardsController: widget.cardsController,
                                    cardType: CardType.multiReload,
                                    maskedCardNumber: widget
                                            .cardsController
                                            .multiLoadableCard
                                            .value
                                            .maskedCardNumber ??
                                        '',
                                    cardUrl: widget.cardsController
                                            .multiLoadableCard.value.cardLink ??
                                        '',
                                    cardReferenceNumber: widget
                                            .cardsController
                                            .multiLoadableCard
                                            .value
                                            .cardReferenceNumber ??
                                        '',
                                    dio: widget.dio),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Center(
                                child: GestureDetector(
                                  onTap: () => Get.to(() =>
                                      const AddMoneyScreen(
                                          type: CardType.multiReloadAddAmount)),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 30),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      gradient: const LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color(0xff6E56FF),
                                            Color(0xff3012E8)
                                          ]),
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
                        ),
                      ),
                    if (widget.dashboardController.selectedCardType.value ==
                            SelectedCardType.multiLoadable &&
                        widget.cardsController.multiLoadableCard.value
                                .cardReferenceNumber !=
                            null &&
                        widget.dashboardController.isLoading.value)
                      SizedBox(
                        height: constraints.maxHeight / 2,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    if (widget.dashboardController.selectedCardType.value ==
                            SelectedCardType.multiLoadable &&
                        widget.cardsController.multiLoadableCard.value
                                .cardReferenceNumber !=
                            null &&
                        widget.dashboardController.multiLoadableCardTransactions
                            .isEmpty &&
                        !widget.dashboardController.isLoading.value)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text('You don\'t have any transactions'),
                        ),
                      ),
                    if (widget.dashboardController.multiLoadableCardTransactions
                        .isNotEmpty)
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Analytics',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            GestureDetector(
                              onTap: () => _pickYear(
                                  context, widget.dashboardController),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: primaryColor),
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Obx(() => Text(
                                          'Year - ${widget.dashboardController.multiLoadableSelectedYear}',
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        )),
                                    const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    const SizedBox(
                      height: 16,
                    ),
                    if (widget.dashboardController.multiLoadableCardTransactions
                        .isNotEmpty)
                      SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          series: <ColumnSeries<Transactions, String>>[
                            ColumnSeries<Transactions, String>(
                                dataSource: <Transactions>[
                                  Transactions(
                                      'Jan',
                                      widget.dashboardController
                                          .getMultiLoadbaleMonthlyTotal('Jan')),
                                  Transactions(
                                      'Feb',
                                      widget.dashboardController
                                          .getMultiLoadbaleMonthlyTotal('Feb')),
                                  Transactions(
                                      'Mar',
                                      widget.dashboardController
                                          .getMultiLoadbaleMonthlyTotal('Mar')),
                                  Transactions(
                                      'Apr',
                                      widget.dashboardController
                                          .getMultiLoadbaleMonthlyTotal('Apr')),
                                  Transactions(
                                      'May',
                                      widget.dashboardController
                                          .getMultiLoadbaleMonthlyTotal('May')),
                                  Transactions(
                                      'Jun',
                                      widget.dashboardController
                                          .getMultiLoadbaleMonthlyTotal('Jun')),
                                  Transactions(
                                      'Jul',
                                      widget.dashboardController
                                          .getMultiLoadbaleMonthlyTotal('Jul')),
                                  Transactions(
                                      'Aug',
                                      widget.dashboardController
                                          .getMultiLoadbaleMonthlyTotal('Aug')),
                                  Transactions(
                                      'Sep',
                                      widget.dashboardController
                                          .getMultiLoadbaleMonthlyTotal('Sep')),
                                  Transactions(
                                      'Oct',
                                      widget.dashboardController
                                          .getMultiLoadbaleMonthlyTotal('Oct')),
                                  Transactions(
                                      'Nov',
                                      widget.dashboardController
                                          .getMultiLoadbaleMonthlyTotal('Nov')),
                                  Transactions(
                                      'Dec',
                                      widget.dashboardController
                                          .getMultiLoadbaleMonthlyTotal('Dec')),
                                ],
                                color: primaryColor.withOpacity(0.5),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4)),
                                onPointTap: (pointInteractionDetails) {
                                  widget
                                          .dashboardController
                                          .isShowMultiLoadableCardMonthlyTransactions
                                          .value =
                                      !widget
                                          .dashboardController
                                          .isShowMultiLoadableCardMonthlyTransactions
                                          .value;
                                  if (widget
                                      .dashboardController
                                      .isShowMultiLoadableCardMonthlyTransactions
                                      .value) {
                                    widget.dashboardController
                                        .getMultiLoadableMonthlyTransactions(
                                            widget.dashboardController.getMonth(
                                                pointInteractionDetails
                                                        .pointIndex ??
                                                    0));
                                  } else {
                                    widget.dashboardController
                                        .multiLoadableMonthlyTransactions
                                        .clear();
                                  }
                                },
                                selectionBehavior: SelectionBehavior(
                                    enable: true,
                                    selectedColor: primaryColor,
                                    toggleSelection: true),
                                xValueMapper: (Transactions sales, _) =>
                                    sales.year,
                                yValueMapper: (Transactions sales, _) =>
                                    sales.sales)
                          ]),
                    if (widget.dashboardController
                        .isShowMultiLoadableCardMonthlyTransactions.value)
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Transactions',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                      ),
                    if (widget.dashboardController
                        .isShowMultiLoadableCardMonthlyTransactions.value)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.dashboardController
                                .multiLoadableMonthlyTransactions.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xfff4f4f4),
                                    borderRadius: BorderRadius.circular(16)),
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget
                                                    .dashboardController
                                                    .multiLoadableMonthlyTransactions[
                                                        index]
                                                    .merchantName ??
                                                'Merchant Name',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            DateFormat.yMMMMEEEEd().format(
                                                DateTime.parse(widget
                                                    .dashboardController
                                                    .multiLoadableMonthlyTransactions[
                                                        index]
                                                    .transactionDate!)),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                color: Color(0xffaaaaaa)),
                                          )
                                        ],
                                      ),
                                      Text(
                                        widget
                                                        .dashboardController
                                                        .multiLoadableMonthlyTransactions[
                                                            index]
                                                        .transactionType ==
                                                    TransactionType
                                                        .debit.value ||
                                                widget
                                                        .dashboardController
                                                        .multiLoadableMonthlyTransactions[
                                                            index]
                                                        .transactionType ==
                                                    TransactionType
                                                        .surchargeDebit.value
                                            ? '-\u{20B9}${widget.dashboardController.multiLoadableMonthlyTransactions[index].transactionAmount}'
                                            : widget
                                                            .dashboardController
                                                            .multiLoadableMonthlyTransactions[
                                                                index]
                                                            .transactionType ==
                                                        TransactionType
                                                            .credit.value ||
                                                    widget
                                                            .dashboardController
                                                            .multiLoadableMonthlyTransactions[
                                                                index]
                                                            .transactionType ==
                                                        TransactionType
                                                            .cashback.value ||
                                                    widget
                                                            .dashboardController
                                                            .multiLoadableMonthlyTransactions[
                                                                index]
                                                            .transactionType ==
                                                        TransactionType
                                                            .refund.value ||
                                                    widget
                                                            .dashboardController
                                                            .multiLoadableMonthlyTransactions[
                                                                index]
                                                            .transactionType ==
                                                        TransactionType
                                                            .reversal.value ||
                                                    widget
                                                            .dashboardController
                                                            .multiLoadableMonthlyTransactions[
                                                                index]
                                                            .transactionType ==
                                                        TransactionType
                                                            .surchargeReversal
                                                            .value
                                                ? '+\u{20B9}${widget.dashboardController.multiLoadableMonthlyTransactions[index].transactionAmount}'
                                                : '\u{20B9}${widget.dashboardController.multiLoadableMonthlyTransactions[index].transactionAmount}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            color: primaryColor),
                                      )
                                    ]),
                              );
                            }),
                      )
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

void _pickYear(BuildContext context, DashboardController dashboardController) {
  showDialog(
    context: context,
    builder: (context) {
      final Size size = MediaQuery.of(context).size;
      return AlertDialog(
        title: const Text('Select a Year'),
        contentPadding: const EdgeInsets.all(10),
        content: SizedBox(
          height: size.height / 3,
          width: size.width,
          child: GridView.count(
            crossAxisCount: 3,
            children: [
              ...List.generate(
                50,
                (index) => InkWell(
                  onTap: () {
                    if (dashboardController.selectedCardType.value ==
                        SelectedCardType.onceLoadable) {
                      dashboardController.selectedYear.value =
                          (DateTime.now().year - index).toString();
                      dashboardController.getYearlyTransaction(
                          dashboardController.selectedYear.value);
                      dashboardController.isShowMonthlyTransactions.value =
                          false;
                      dashboardController.monthlyTransactions.clear();
                    } else {
                      dashboardController.multiLoadableSelectedYear.value =
                          (DateTime.now().year - index).toString();
                      dashboardController.getYearlyMultiLoadableCardTransaction(
                          dashboardController.multiLoadableSelectedYear.value);
                      dashboardController
                          .isShowMultiLoadableCardMonthlyTransactions
                          .value = false;
                      dashboardController.multiLoadableMonthlyTransactions
                          .clear();
                    }
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Chip(
                      label: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          (DateTime.now().year - index).toString(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class Transactions {
  Transactions(this.year, this.sales);
  final String year;
  final double sales;
}
