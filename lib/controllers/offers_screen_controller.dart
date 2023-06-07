import 'package:bachat_cards/models/offer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class OffersController extends GetxController {
  var offers = <Offer>[].obs;
  var filteredList = <Offer>[].obs;
  var foodOffers = <Offer>[];
  var electronicsOffers = <Offer>[];
  var shoppingOffers = <Offer>[];

  Future<List<Offer>> getOffers(Dio dio) async {
    offers.clear();
    try {
      final response =
          await dio.get('https://api.meribachat.in/v1/rupay-offers');
      for (int i = 0; i < response.data['data'].length; i++) {
        offers.add(Offer.fromJson(response.data['data'][i]));
      }
    } on DioError catch (e) {
      debugPrint('GetOffers: ${e.response}');
    }
    getFoodOffers();
    getShoppingOffer();
    getElectronicsOffers();
    return offers;
  }

  List<Offer> getFoodOffers() {
    foodOffers.clear();
    for (Offer offer in offers) {
      if (offer.tags != null && offer.tags!.isNotEmpty) {
        for (String s in offer.tags!) {
          if (s.toLowerCase() == 'dining') {
            foodOffers.add(offer);
          }
        }
      }
    }
    return foodOffers;
  }

  List<Offer> getShoppingOffer() {
    shoppingOffers.clear();
    for (Offer offer in offers) {
      if (offer.tags != null && offer.tags!.isNotEmpty) {
        for (String s in offer.tags!) {
          if (s.toLowerCase() == 'shopping') {
            shoppingOffers.add(offer);
          }
        }
      }
    }
    return shoppingOffers;
  }

  List<Offer> getElectronicsOffers() {
    electronicsOffers.clear();
    for (Offer offer in offers) {
      if (offer.tags != null && offer.tags!.isNotEmpty) {
        for (String s in offer.tags!) {
          if (s.toLowerCase() == 'electronics') {
            electronicsOffers.add(offer);
          }
        }
      }
    }
    return electronicsOffers;
  }

  List<Offer> getFilteredOffers(String filterName) {
    filteredList.clear();
    for (Offer offer in offers) {
      if (offer.tags != null && offer.tags!.isNotEmpty) {
        for (String s in offer.tags!) {
          if (s.toLowerCase() == filterName.toLowerCase()) {
            filteredList.add(offer);
          }
        }
      }
    }
    return filteredList;
  }
}
