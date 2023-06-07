import 'package:bachat_cards/sevrices/shared_prefs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../Constants/constants.dart';
import '../models/voucher.dart';

class VouchersController extends GetxController {
  List<Voucher> vouchers = <Voucher>[].obs;
  var isLoading = false.obs;
  final Dio dio = Dio(BaseOptions(
      headers: {'Authorization': 'Bearer ${SharedPrefs.getToken()}'}));

  @override
  void onInit() {
    getVouchers(dio);
    super.onInit();
  }

  Future<List<Voucher>> getVouchers(Dio dio) async {
    isLoading.value = true;
    vouchers.clear();
    try {
      final response = await dio.get('${Constants.url}/mbc/v1/redeem/order',
          queryParameters: {
            'userId': SharedPrefs.getUserEarnestId(),
            'status': 'C'
          });
      for (int i = 0; i < response.data['result'].length; i++) {
        Voucher v = Voucher.fromJson(response.data['result'][i]);
        vouchers.add(v);
      }
    } on DioError catch (e) {
      debugPrint('getVouchers: ${e.response}');
    }
    isLoading.value = false;
    return vouchers;
  }
}
