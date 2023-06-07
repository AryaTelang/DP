// ignore_for_file: prefer_final_fields

import 'package:bachat_cards/appbar/appbar.dart';
import 'package:bachat_cards/models/card_order.dart';
import 'package:bachat_cards/models/reload_order.dart';
import 'package:bachat_cards/sevrices/shared_prefs.dart';
import 'package:bachat_cards/theme/theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Constants/constants.dart';

// ignore: must_be_immutable
class OrderDetailsScreen extends StatelessWidget {
  OrderDetailsScreen(
      {super.key,
      required this.orderReferenceNumber,
      required this.detailsType});

  final String orderReferenceNumber;
  final DetailsType detailsType;
  var _cardOrder = CardOrder().obs;
  var _reloadOrder = ReloadOrder().obs;
  final TextStyle _textStyle = const TextStyle(
      fontFamily: 'Montserrat', fontSize: 14, fontWeight: FontWeight.w500);
  final Dio dio = Dio(BaseOptions(
      headers: {'Authorization': 'Bearer ${SharedPrefs.getToken()}'}));

  void callDetailsHook(String orderReferenceNumber) {
    dio.get('${Constants.url}/mbc/v1/order/detailsHook', queryParameters: {
      'orderId': orderReferenceNumber,
    });
  }

  Future<CardOrder> getOrderDetails(String orderReferenceNumber) async {
    try {
      final response = await dio.get('${Constants.url}/mbc/v1/order/card',
          queryParameters: {
            'orderId': orderReferenceNumber,
            'userId': SharedPrefs.getUserEarnestId()
          });
      _cardOrder.value = CardOrder.fromJson(response.data['result'][0]);
    } on DioError catch (e) {
      if (kDebugMode) {
        print('Get order detials: ${e.response}');
      }
    }
    return _cardOrder.value;
  }

  Future<ReloadOrder> getReloadOrderDetails(String orderReferenceNumber) async {
    try {
      final response = await dio.get('${Constants.url}/mbc/v1/order/reload',
          queryParameters: {
            'orderId': orderReferenceNumber,
            'userId': SharedPrefs.getUserEarnestId()
          });
      _cardOrder.value = CardOrder.fromJson(response.data['result'][0]);
      _cardOrder.value.orderId = response.data['result'][0]['reloadOrderId'];
      if (response.data['result'][0]['cardDetailList'] != null) {
        _cardOrder.value.orderAmount =
            response.data['result'][0]['cardDetailList'][0]['amount'];
      }
    } on DioError catch (e) {
      if (kDebugMode) {
        print('getReload order details: ${e.response}');
      }
    }
    return _reloadOrder.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppBar(
        appBar: AppBar(),
        title: Text(
          'Order Details',
          style: poppinsSemiBold18.copyWith(color: Colors.black),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          detailsType == DetailsType.multiLoadable
              ? await getReloadOrderDetails(orderReferenceNumber)
              : await getOrderDetails(orderReferenceNumber);
          callDetailsHook(orderReferenceNumber);
        },
        child: FutureBuilder(
          future: detailsType == DetailsType.onceLoadable
              ? getOrderDetails(orderReferenceNumber)
              : getReloadOrderDetails(orderReferenceNumber),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              return LayoutBuilder(builder: (context, constraints) {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                      minWidth: constraints.maxWidth),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Obx(
                        () => Card(
                          elevation: 5,
                          child: ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              Container(
                                color: secondaryColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: detailsType == DetailsType.multiLoadable
                                    ? const Text(
                                        'Reloadable',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      )
                                    : Row(
                                        children: [
                                          Text(
                                            toBeginningOfSentenceCase(_cardOrder
                                                    .value.reloadType) ??
                                                '',
                                            style: const TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                          const Spacer(),
                                          const Text(
                                            'New card',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                              ),
                              _textItem(
                                  text: 'Order Id',
                                  value: '${_cardOrder.value.orderId ?? ''}',
                                  textStyle: _textStyle),
                              if (_cardOrder.value.externalOrderId != null)
                                _textItem(
                                    text: 'external order Id',
                                    value:
                                        _cardOrder.value.externalOrderId ?? '',
                                    textStyle: _textStyle),
                              _textItem(
                                  text: 'Amount',
                                  value: _cardOrder.value.orderAmount ?? '',
                                  textStyle: _textStyle),
                              Obx(
                                () => _textItem(
                                  text: 'Order Status',
                                  value: _cardOrder.value.paymentStatus == 'F'
                                      ? 'Failed'
                                      : toBeginningOfSentenceCase(
                                              _cardOrder.value.orderStatus ??
                                                  '') ??
                                          '',
                                  textStyle: _textStyle.copyWith(
                                      color: _cardOrder.value.paymentStatus ==
                                              'F'
                                          ? Colors.red
                                          : _cardOrder.value.orderStatus ==
                                                  'success'
                                              ? Colors.green
                                              : _cardOrder.value.orderStatus ==
                                                      'pending'
                                                  ? Colors.orange
                                                  : Colors.red),
                                ),
                              ),
                              if (_cardOrder.value.reloadType != 'reloadable')
                                Obx(
                                  () => _textItem(
                                      text: 'Payment Status',
                                      value: _cardOrder.value.paymentStatus ==
                                              'C'
                                          ? 'Success'
                                          : _cardOrder.value.paymentStatus ==
                                                  'P'
                                              ? 'Pending'
                                              : 'Failed',
                                      textStyle: _textStyle.copyWith(
                                          color:
                                              _cardOrder.value.paymentStatus ==
                                                      'C'
                                                  ? Colors.green
                                                  : _cardOrder.value
                                                              .paymentStatus ==
                                                          'P'
                                                      ? Colors.orange
                                                      : Colors.red)),
                                ),
                              _textItem(
                                  text: 'Order date',
                                  value: DateFormat('EEEE, MMMM dd, yyyy')
                                      .format(DateTime.parse(
                                              _cardOrder.value.createdAt!)
                                          .toLocal()),
                                  textStyle: _textStyle),
                              _textItem(
                                  text: 'Order time',
                                  value: DateFormat.jm().format(DateTime.parse(
                                          _cardOrder.value.createdAt!)
                                      .toLocal()),
                                  textStyle: _textStyle),
                              const SizedBox(
                                height: 12,
                              ),
                              Center(
                                child: Text(
                                  'Ref. Number',
                                  style: _textStyle,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Center(
                                child: Text(
                                  _cardOrder.value.referenceNumber ?? '',
                                  style: _textStyle,
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Some error occured'),
              );
            }
            return const Center(
              child: Text('None'),
            );
          }),
        ),
      ),
    );
  }

  Widget _textItem(
      {required String text, required String value, TextStyle? textStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
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
          Expanded(
              flex: 3,
              child: Text(
                value,
                style: textStyle,
                textAlign: TextAlign.right,
              ))
        ],
      ),
    );
  }
}
