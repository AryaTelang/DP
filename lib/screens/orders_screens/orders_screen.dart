import 'dart:convert';

import 'package:bachat_cards/Constants/constants.dart';
import 'package:bachat_cards/controllers/orders_controller.dart';
import 'package:bachat_cards/models/card_order.dart';
import 'package:bachat_cards/models/reload_order.dart';
import 'package:bachat_cards/models/voucher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../sevrices/shared_prefs.dart';
import '../../theme/theme.dart';
import 'order_details_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  final ordersController = Get.put(OrdersController());

  late final TabController tabController;
  final Dio dio = Dio(BaseOptions(
      headers: {'Authorization': 'Bearer ${SharedPrefs.getToken()}'}));

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
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
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: poppinsSemiBold18.copyWith(color: Colors.black),
        ),
        bottom: TabBar(
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.label,
            padding: EdgeInsets.zero,
            controller: tabController,
            labelColor: Colors.black,
            labelStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            indicatorColor: primaryColor,
            tabs: const [
              Tab(
                text: "Card orders",
              ),
              Tab(
                text: "Multi-card reload orders",
              ),
              Tab(
                text: 'Voucher orders',
              )
            ]),
      ),
      body: TabBarView(controller: tabController, children: [
        CardOrdersWidget(ordersController: ordersController, dio: dio),
        ReloadOrdersWidget(ordersController: ordersController, dio: dio),
        VoucherOrdersWidget(ordersController: ordersController, dio: dio)
      ]),
    );
  }
}

class VoucherOrdersWidget extends StatelessWidget {
  const VoucherOrdersWidget(
      {Key? key, required this.ordersController, required this.dio})
      : super(key: key);

  final OrdersController ordersController;
  final Dio dio;

  final _tableTextStyle =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => ordersController.getVoucherOrders(dio),
      child: Obx(() {
        if (ordersController.isVouchersLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!ordersController.isVouchersLoading.value &&
            ordersController.voucherOrders.isEmpty) {
          return LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    minWidth: constraints.maxWidth),
                child: const Center(
                  child: Text('No orders found!!'),
                ),
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView.builder(
            itemCount: ordersController.voucherOrders.length,
            itemBuilder: (context, index) {
              Voucher v = ordersController.voucherOrders[index];
              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: CachedNetworkImage(
                        imageUrl: ordersController
                            .voucherOrders[index].brand!.brandLogo!,
                        errorWidget: (context, url, error) =>
                            SvgPicture.asset('assets/images/errorImage.svg'),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Brand Name: ${v.brand!.name ?? ''}',
                            style: _tableTextStyle,
                          ),
                          Text(
                            'Amount: \u{20B9}${v.amount}',
                            style: _tableTextStyle,
                          ),
                          Text(
                            'Order Id: \u{20B9}${v.redemptionId}',
                            style: _tableTextStyle,
                          ),
                          Text(
                            'Date: ${DateFormat.yMMMMd().format(DateTime.parse(v.createdAt!).toLocal())}',
                            style: _tableTextStyle,
                          ),
                          Text(
                            'Status: ${v.status == 'C' ? 'Success' : v.status == 'P' ? 'Pending' : 'Failed'}',
                            style: _tableTextStyle.copyWith(
                                color: v.status == 'C'
                                    ? Colors.green
                                    : v.status == 'P'
                                        ? Colors.orange[500]
                                        : Colors.red),
                          )
                        ],
                      ),
                    )
                  ]),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class ReloadOrdersWidget extends StatelessWidget {
  const ReloadOrdersWidget(
      {Key? key, required this.ordersController, required this.dio})
      : super(key: key);

  final OrdersController ordersController;
  final Dio dio;

  final _tableTextStyle =
      const TextStyle(fontSize: 12, fontWeight: FontWeight.w500);

  final TextStyle _textStyle =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        ordersController.reloadOrders.clear();
        return ordersController.getReloadOrders(dio);
      },
      child: Obx(() {
        if (ordersController.isReloadOrdersLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!ordersController.isReloadOrdersLoading.value &&
            ordersController.reloadOrders.isEmpty) {
          return LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    minWidth: constraints.maxWidth),
                child: const Center(
                  child: Text('No orders found!!'),
                ),
              ),
            ),
          );
        }
        return Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'ID',
                      textAlign: TextAlign.center,
                      style: _tableTextStyle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Date',
                      textAlign: TextAlign.center,
                      style: _tableTextStyle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Amount',
                      textAlign: TextAlign.center,
                      style: _tableTextStyle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Status',
                      textAlign: TextAlign.center,
                      style: _tableTextStyle,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: ordersController.reloadOrders.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.to(() => OrderDetailsScreen(
                            orderReferenceNumber: ordersController
                                    .reloadOrders[index].referenceNumber ??
                                '',
                            detailsType: DetailsType.multiLoadable));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                ordersController
                                        .reloadOrders[index].referenceNumber ??
                                    '',
                                textAlign: TextAlign.center,
                                style: _tableTextStyle.copyWith(
                                    color: Colors.blue),
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Expanded(
                              child: Text(
                                DateFormat('dd MMM yyyy').format(DateTime.parse(
                                        ordersController
                                            .reloadOrders[index].createdAt!)
                                    .toLocal()),
                                textAlign: TextAlign.center,
                                style: _tableTextStyle,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                ordersController.reloadOrders[index]
                                            .cardDetailList !=
                                        null
                                    ? ordersController.reloadOrders[index]
                                            .cardDetailList![0].amount ??
                                        ''
                                    : '',
                                textAlign: TextAlign.center,
                                style: _tableTextStyle,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                ordersController
                                        .reloadOrders[index].orderStatus ??
                                    '',
                                textAlign: TextAlign.center,
                                style: _tableTextStyle.copyWith(
                                    color: ordersController.reloadOrders[index]
                                                .orderStatus ==
                                            'success'
                                        ? Colors.green
                                        : ordersController.reloadOrders[index]
                                                    .orderStatus ==
                                                'pending'
                                            ? Colors.orange
                                            : Colors.red),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        );
      }),
    );
  }

  void showDetailsDialog(
      BuildContext context, DetailsType detailsType, ReloadOrder cardOrder) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actions: [
                TextButton(onPressed: () => Get.back(), child: const Text('Ok'))
              ],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              content: Container(
                color: Colors.white,
                // padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    _textItem(
                        text: 'Order Id',
                        value: '${cardOrder.reloadOrderId ?? ''}',
                        textStyle: _textStyle),
                    _textItem(
                        text: 'external order Id',
                        value: cardOrder.externalOrderId ?? '',
                        textStyle: _textStyle),
                    _textItem(
                        text: 'Amount',
                        value: cardOrder.orderAmount ?? '',
                        textStyle: _textStyle),
                    _textItem(
                        text: 'Order Status',
                        value: cardOrder.orderStatus ?? '',
                        textStyle: _textStyle.copyWith(
                            color: cardOrder.orderStatus == 'success'
                                ? Colors.green
                                : cardOrder.orderStatus == 'pending'
                                    ? Colors.orange
                                    : Colors.red)),
                    _textItem(
                        text: 'Payment Status',
                        value: cardOrder.paymentStatus == 'C'
                            ? 'Success'
                            : cardOrder.paymentStatus == 'P'
                                ? 'Pending'
                                : 'Failed',
                        textStyle: _textStyle.copyWith(
                            color: cardOrder.paymentStatus == 'C'
                                ? Colors.green
                                : cardOrder.paymentStatus == 'P'
                                    ? Colors.orange
                                    : Colors.red)),
                    _textItem(
                        text: 'Order date',
                        value: DateFormat('EEEE, MMMM dd, yyyy').format(
                            DateTime.parse(cardOrder.createdAt!).toLocal()),
                        textStyle: _textStyle),
                    _textItem(
                        text: 'Order time',
                        value: DateFormat.jm().format(
                            DateTime.parse(cardOrder.createdAt!).toLocal()),
                        textStyle: _textStyle),
                    _textItem(
                        text: 'Ref. Number',
                        value: cardOrder.referenceNumber ?? '',
                        textStyle: _textStyle),
                  ],
                ),
              ),
            ));
  }

  Widget _textItem(
      {required String text, required String value, TextStyle? textStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              text,
              style: _textStyle,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(flex: 3, child: Text(value, style: textStyle))
        ],
      ),
    );
  }
}

class CardOrdersWidget extends StatelessWidget {
  const CardOrdersWidget(
      {Key? key, required this.ordersController, required this.dio})
      : super(key: key);

  final OrdersController ordersController;
  final Dio dio;
  final _tableTextStyle =
      const TextStyle(fontSize: 12, fontWeight: FontWeight.w500);

  final TextStyle _textStyle =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        ordersController.cardOrders.clear();
        return ordersController.getCardOrders(dio);
      },
      child: Obx(() {
        if (ordersController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!ordersController.isLoading.value &&
            ordersController.cardOrders.isEmpty) {
          return LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    minWidth: constraints.maxWidth),
                child: const Center(
                  child: Text('No orders found!!'),
                ),
              ),
            ),
          );
        }
        return Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 32,
                  ),
                  Expanded(
                    child: Text(
                      'ID',
                      textAlign: TextAlign.center,
                      style: _tableTextStyle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Date',
                      textAlign: TextAlign.center,
                      style: _tableTextStyle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Amount',
                      textAlign: TextAlign.center,
                      style: _tableTextStyle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Card Ref. No.',
                      textAlign: TextAlign.center,
                      style: _tableTextStyle,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: ordersController.cardOrders.length,
                  itemBuilder: (context, index) {
                    String? cardRefNo;
                    if (ordersController.cardOrders[index].orderResponse !=
                            null &&
                        jsonDecode(ordersController.cardOrders[index]
                                .orderResponse!)['cardDetailResponseList'] !=
                            null) {
                      if (jsonDecode(ordersController.cardOrders[index]
                                  .orderResponse!)['cardDetailResponseList'][0]
                              ['referenceNumber'] !=
                          null) {
                        cardRefNo = jsonDecode(ordersController
                                    .cardOrders[index]
                                    .orderResponse!)['cardDetailResponseList']
                                [0]['referenceNumber']
                            .toString();
                      }
                    }
                    return InkWell(
                      onTap: () {
                        Get.to(() => OrderDetailsScreen(
                            orderReferenceNumber: ordersController
                                    .cardOrders[index].referenceNumber ??
                                '',
                            detailsType: DetailsType.onceLoadable));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          children: [
                            SizedBox(
                                height: 32,
                                child: Image.asset(
                                  ordersController
                                              .cardOrders[index].reloadType ==
                                          'reloadable'
                                      ? 'assets/images/money.png'
                                      : 'assets/images/once_load_rupay.png',
                                  color: primaryColor,
                                )),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(
                                ordersController
                                        .cardOrders[index].referenceNumber ??
                                    '',
                                textAlign: TextAlign.center,
                                style: _tableTextStyle.copyWith(
                                    color: Colors.blue),
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Expanded(
                              child: Text(
                                DateFormat('dd MMM yyyy').format(DateTime.parse(
                                        ordersController
                                            .cardOrders[index].createdAt!)
                                    .toLocal()),
                                textAlign: TextAlign.center,
                                style: _tableTextStyle,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                ordersController
                                        .cardOrders[index].orderAmount ??
                                    '',
                                textAlign: TextAlign.center,
                                style: _tableTextStyle,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  if (cardRefNo != null)
                                    Text(
                                      cardRefNo,
                                      textAlign: TextAlign.center,
                                      style: _tableTextStyle,
                                    ),
                                  Text(
                                    ordersController.cardOrders[index]
                                                .paymentStatus ==
                                            "F"
                                        ? 'Status : failed'
                                        : 'Status : ${ordersController.cardOrders[index].orderStatus}',
                                    textAlign: TextAlign.center,
                                    style: _tableTextStyle.copyWith(
                                        color: ordersController
                                                    .cardOrders[index]
                                                    .paymentStatus ==
                                                "F"
                                            ? Colors.red
                                            : ordersController.cardOrders[index]
                                                        .orderStatus ==
                                                    'success'
                                                ? Colors.green
                                                : ordersController
                                                            .cardOrders[index]
                                                            .orderStatus ==
                                                        'pending'
                                                    ? Colors.orange
                                                    : Colors.red),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        );
      }),
    );
  }

  void showDetailsDialog(
      BuildContext context, DetailsType detailsType, CardOrder cardOrder) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actions: [
                TextButton(onPressed: () => Get.back(), child: const Text('Ok'))
              ],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              content: Container(
                color: Colors.white,
                // padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    if (detailsType == DetailsType.onceLoadable)
                      Text(
                        '${toBeginningOfSentenceCase(cardOrder.cardType)} - ${toBeginningOfSentenceCase(cardOrder.reloadType)}',
                        style: _textStyle,
                      ),
                    _textItem(
                        text: 'Order Id',
                        value: '${cardOrder.orderId ?? ''}',
                        textStyle: _textStyle),
                    _textItem(
                        text: 'external order Id',
                        value: cardOrder.externalOrderId ?? '',
                        textStyle: _textStyle),
                    _textItem(
                        text: 'Amount',
                        value: cardOrder.orderAmount ?? '',
                        textStyle: _textStyle),
                    _textItem(
                        text: 'Order Status',
                        value: cardOrder.orderStatus ?? '',
                        textStyle: _textStyle.copyWith(
                            color: cardOrder.orderStatus == 'success'
                                ? Colors.green
                                : cardOrder.orderStatus == 'pending'
                                    ? Colors.orange
                                    : Colors.red)),
                    _textItem(
                        text: 'Payment Status',
                        value: cardOrder.paymentStatus == 'C'
                            ? 'Success'
                            : cardOrder.paymentStatus == 'P'
                                ? 'Pending'
                                : 'Failed',
                        textStyle: _textStyle.copyWith(
                            color: cardOrder.paymentStatus == 'C'
                                ? Colors.green
                                : cardOrder.paymentStatus == 'P'
                                    ? Colors.orange
                                    : Colors.red)),
                    _textItem(
                        text: 'Order date',
                        value: DateFormat('EEEE, MMMM dd, yyyy').format(
                            DateTime.parse(cardOrder.createdAt!).toLocal()),
                        textStyle: _textStyle),
                    _textItem(
                        text: 'Order time',
                        value: DateFormat.jm().format(
                            DateTime.parse(cardOrder.createdAt!).toLocal()),
                        textStyle: _textStyle),
                    _textItem(
                        text: 'Ref. Number',
                        value: cardOrder.referenceNumber ?? '',
                        textStyle: _textStyle),
                  ],
                ),
              ),
            ));
  }

  Widget _textItem(
      {required String text, required String value, TextStyle? textStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              text,
              style: _textStyle,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(flex: 3, child: Text(value, style: textStyle))
        ],
      ),
    );
  }
}
