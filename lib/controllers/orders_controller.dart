import 'package:bachat_cards/Constants/constants.dart';
import 'package:bachat_cards/models/card_order.dart';
import 'package:bachat_cards/models/reload_order.dart';
import 'package:bachat_cards/models/voucher.dart';
import 'package:bachat_cards/sevrices/shared_prefs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class OrdersController extends GetxController {
  var cardOrders = <CardOrder>[].obs;
  var isLoading = false.obs;
  var isReloadOrdersLoading = false.obs;
  var isVouchersLoading = false.obs;
  var page = 1.obs;
  var reloadOrders = <ReloadOrder>[].obs;
  var voucherOrders = <Voucher>[].obs;
  final Dio dio = Dio(BaseOptions(
      headers: {'Authorization': 'Bearer ${SharedPrefs.getToken()}'}));

  @override
  void onInit() {
    getCardOrders(dio);
    getReloadOrders(dio);
    getVoucherOrders(dio);
    super.onInit();
  }

  Future<List<Voucher>> getVoucherOrders(Dio dio) async {
    isVouchersLoading.value = true;
    voucherOrders.clear();
    try {
      final response = await dio
          .get('${Constants.url}/mbc/v1/redeem/order', queryParameters: {
        'userId': SharedPrefs.getUserEarnestId(),
      });
      for (int i = 0; i < response.data['result'].length; i++) {
        voucherOrders.add(Voucher.fromJson(response.data['result'][i]));
      }
    } on DioError catch (e) {
      debugPrint('get Vouchers order: ${e.response}');
    }
    isVouchersLoading.value = false;
    return voucherOrders;
  }

  Future<List<CardOrder>> getCardOrders(Dio dio) async {
    isLoading.value = true;
    try {
      final response = await dio
          .get('${Constants.url}/mbc/v1/order/card', queryParameters: {
        'userId': SharedPrefs.getUserEarnestId(),
      });
      if (response.data['result'] != null) {
        for (int i = 0; i < response.data['result'].length; i++) {
          cardOrders.add(CardOrder.fromJson(response.data['result'][i]));
        }
      }
    } on DioError catch (e) {
      debugPrint('Get orders: ${e.response}');
    }
    isLoading.value = false;
    return cardOrders;
  }

  Future<void> getReloadOrders(Dio dio) async {
    isReloadOrdersLoading.value = true;
    try {
      final response = await dio
          .get('${Constants.url}/mbc/v1/order/reload', queryParameters: {
        'userId': SharedPrefs.getUserEarnestId(),
      });
      if (response.data['result'] != null) {
        for (int i = 0; i < response.data['result'].length; i++) {
          reloadOrders.add(ReloadOrder.fromJson(response.data['result'][i]));
        }
      }
    } on DioError catch (e) {
      debugPrint('Reload Orders: ${e.response}');
    }
    isReloadOrdersLoading.value = false;
  }
}
