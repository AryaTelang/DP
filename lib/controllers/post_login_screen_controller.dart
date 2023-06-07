import 'dart:convert';

import 'package:bachat_cards/Constants/constants.dart';
import 'package:bachat_cards/models/user_profile_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../sevrices/shared_prefs.dart';

class PostLoginScreenController extends GetxController {
  var index = 0.obs;
  final PageController pageController = PageController();
  var userProfile = UserProfile().obs;

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  updateIndex(int i) {
    index.value = i;
    pageController.jumpToPage(i);
  }

  Future<UserProfile> getUserinfo(Dio dio) async {
    try {
      final response = await dio.get('${Constants.url}/um/v1/viewProfile',
          queryParameters: {'user_id': SharedPrefs.getUserEarnestId()});
      userProfile.value = UserProfile.fromJson(jsonDecode(response.toString()));
    } on DioError catch (e) {
      Get.snackbar('Error', e.message ?? '');
      debugPrint('getUserInfo: ${e.response}');
    }
    return userProfile.value;
  }
}
