import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../Constants/constants.dart';
import '../models/rewards.dart';

class SearchController extends GetxController {
  var searchedList = <Brands>[].obs;
  var isLoading = false.obs;
  late Timer debounce;

  @override
  void onInit() {
    debounce = Timer(const Duration(milliseconds: 250), () {});
    super.onInit();
  }

  void handleSearch(String value, Dio dio) async {
    isLoading.value = true;
    debounce.cancel();
    debounce = Timer(const Duration(milliseconds: 350), () async {
      await searchBrands(value, dio);
    });
  }

  Future<List<Brands>> searchBrands(String searchQuery, Dio dio) async {
    isLoading.value = true;
    searchedList.clear();
    try {
      final response = await dio.get('${Constants.url}/mb-be/search',
          queryParameters: {'q': searchQuery});
      for (int i = 0; i < response.data['brands'].length; i++) {
        searchedList.add(Brands.fromJson(response.data['brands'][i]));
      }
    } on DioError catch (e) {
      debugPrint('searchBrand: ${e.response}');
    }
    isLoading.value = false;
    return searchedList;
  }
}
