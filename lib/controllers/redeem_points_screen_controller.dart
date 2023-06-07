import 'package:bachat_cards/controllers/post_login_screen_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Constants/constants.dart';
import '../sevrices/shared_prefs.dart';

class RedeemPointsScreenController extends GetxController {
  RxInt selectedChip = 0.obs;
  final TextEditingController pointsEditingControler = TextEditingController();
  var finalAmount = 0.0.obs;
  var isLoading = false.obs;
  Map<String, dynamic> b = {};

  @override
  void onClose() {
    pointsEditingControler.dispose();
    super.onClose();
  }

  updateSelectedChip(int chipAmount) {
    selectedChip.value = chipAmount;
  }

  // getFinalAmount(double discount) {
  //   finalAmount.value =
  //       selectedChip.value - (selectedChip.value * discount / 100);
  //   return finalAmount;
  // }

  Future<Map<String, dynamic>> getBrandById(String brandId, Dio dio) async {
    try {
      final response = await dio.get(
          'https://staging.meribachat.in/mb-be/brand/id/$brandId',
          queryParameters: {'metadata': true});
      b = response.data;
      return b;
    } on DioError catch (e) {
      debugPrint('GetBrandbyId: ${e.response}');
    }
    return b;
  }

  Future<String> redeemGiftCard(Dio dio,
      {required int amount,
      required String denomination,
      required String brandId}) async {
    isLoading.value = true;
    try {
      final response =
          await dio.post('${Constants.url}/mbc/v1/redeem/order', data: {
        'userId': int.parse(SharedPrefs.getUserEarnestId()),
        "amount": amount,
        "denomination": int.parse(denomination),
        "brandId": brandId,
        "email": Get.find<PostLoginScreenController>()
            .userProfile
            .value
            .userInfo!
            .email,
        "mobileNumber": SharedPrefs.getPhoneNumber()
      });
      if (response.data['message'].contains('Order processed Successfully')) {
        isLoading.value = false;
        return 'success';
      }
    } on DioError catch (e) {
      debugPrint('Redeem giftcard: ${e.response}');
      isLoading.value = false;
      return 'error';
    }
    isLoading.value = false;
    return '';
  }
}
