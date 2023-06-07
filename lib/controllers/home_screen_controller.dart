import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../Constants/constants.dart';
import '../models/kyc.dart';
import '../sevrices/shared_prefs.dart';

class HomeScreenController extends GetxController {
  var selectedCardType = SelectedCardType.onceLoadable.obs;
  var kycList = <Kyc>[].obs;
  late PageController cardsPageController;
  PageController cardsIntroController = PageController();
  PageController carouselController = PageController();
  var carouselIndex = 0.obs;
  var selectedIntroType = SelectedCardType.onceLoadable.obs;
  var userBalance = 0.0.obs;
  var isLoading = false.obs;
  var currentCard = 1.obs;
  YoutubePlayerController youtubeController = YoutubePlayerController(
      initialVideoId: 'IhKGC0pS8qE',
      flags: const YoutubePlayerFlags(
          autoPlay: false,
          enableCaption: false,
          showLiveFullscreenButton: false));

  @override
  void onClose() {
    cardsIntroController.dispose();
    cardsPageController.dispose();
    super.onClose();
  }

  Future<void> getKycStatus(Dio dio) async {
    kycList.clear();
    try {
      final response = await dio.get('${Constants.url}/mbc/v1/card/kycStatus');
      if (response.data['result'].isNotEmpty) {
        for (int i = 0; i < response.data['result'].length; i++) {
          kycList.add(Kyc.fromJson(response.data['result'][0]));
        }
      }
    } on DioError catch (e) {
      debugPrint(e.response.toString());
    }
  }

  Future getUserBalance(Dio dio) async {
    try {
      final response = await dio.get('${Constants.url}/mbc/v1/cashback/balance',
          queryParameters: {
            'userId': SharedPrefs.getUserEarnestId(),
            'pageNo': 1
          });
      userBalance.value = double.tryParse(
              response.data['result']['balanceAmount'].toString()) ??
          0.0;
    } on DioError catch (e) {
      Get.snackbar('Error getting balance',
          'Some error occured while trying to get you balance');
      debugPrint('get balance:${e.response}');
    }
    return userBalance;
  }
}
