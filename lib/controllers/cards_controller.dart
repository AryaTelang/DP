import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../Constants/constants.dart';
import '../models/card.dart';
import '../sevrices/shared_prefs.dart';

class CardsController extends GetxController {
  var cardsList = <Card>[].obs;
  var onceLoadableCards = <Card>[].obs;
  var multiLoadableCard = Card().obs;

  Future<List<Card>> getUserCards(Dio dio) async {
    cardsList.clear();
    try {
      final response = await dio.get('${Constants.url}/mbc/v1/card',
          queryParameters: {'userId': SharedPrefs.getUserEarnestId()});

      for (int i = 0; i < response.data['result'].length; i++) {
        cardsList.add(Card.fromJson(response.data['result'][i]));
      }
    } on DioError catch (e) {
      Get.snackbar('Error getting cards', 'Some error occured');
      debugPrint('GetCards: ${e.response}');
    }
    getOnceLoadableCards();
    getMultiLoadableCard();
    return cardsList;
  }

  void getOnceLoadableCards() {
    onceLoadableCards.clear();
    for (Card c in cardsList) {
      if (c.reloadType == 'nonreloadable') {
        onceLoadableCards.add(c);
      }
    }
  }

  void getMultiLoadableCard() {
    for (Card c in cardsList) {
      if (c.reloadType == 'reloadable') {
        multiLoadableCard.value = c;
        break;
      }
    }
  }
}
