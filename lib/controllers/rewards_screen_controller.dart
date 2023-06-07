import 'dart:async';

import 'package:bachat_cards/models/carousel.dart';
import 'package:bachat_cards/models/rewards.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../Constants/constants.dart';

class RewardsScreenController extends GetxController {
  var rewards = <Rewards>[].obs;
  var carouselImages = <Carousel>[].obs;
  var filteredList = <Brands>[].obs;
  PageController carouselController = PageController();
  var carouselIndex = 0.obs;

  Future<List<Rewards>> getRewards(Dio dio) async {
    rewards.clear();
    try {
      final response = await dio.get('${Constants.url}/mb-be/firstPage');
      if (response.statusCode == 200) {
        for (int i = 0; i < response.data['brands'].length; i++) {
          rewards.add(Rewards.fromJson(response.data['brands'][i]));
        }
        for(int i=0;i<response.data['mobileImagesWithLink'].length;i++){
          carouselImages.add(Carousel.fromJson(response.data['mobileImagesWithLink'][i]));
        }
      }
    } on DioError catch (e) {
      debugPrint('getRewards : $e');
    }
    return rewards;
  }

  Future<List<Brands>> getBrandsByCategory(String category, Dio dio) async {
    filteredList.clear();
    try {
      final response = await dio.get(
          '${Constants.url}/mb-be/brand/category/${category.toLowerCase()}');
      if (response.data['brands'].isNotEmpty) {
        for (int i = 0; i < response.data['brands'].length; i++) {
          filteredList.add(Brands.fromJson(response.data['brands'][i]));
        }
      }
    } on DioError catch (e) {
      debugPrint('getFilteredRewards :${e.response}');
    }
    return filteredList;
  }
}
