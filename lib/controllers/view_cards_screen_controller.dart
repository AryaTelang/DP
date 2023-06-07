import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Constants/constants.dart';
import '../models/transaction.dart';

class ViewCardsScreenController extends GetxController {
  var selectedCardType = SelectedCardType.onceLoadable.obs;
  var isLoading = false.obs;
  final List<Transaction> transactions = <Transaction>[].obs;

  late PageController cardsPageController;
  var currentCard = 1.obs;

  Future<List<Transaction>> getTransactions(
      String cardReferenceNumber, Dio dio) async {
    isLoading.value = true;
    transactions.clear();
    try {
      final response = await dio.get('${Constants.url}/mbc/v1/transaction',
          queryParameters: {'cardReferenceNumber': cardReferenceNumber});
      for (int i = 0; i < response.data['transactionDetailList'].length; i++) {
        transactions.add(
            Transaction.fromJson(response.data['transactionDetailList'][i]));
      }
    } on DioError catch (e) {
      debugPrint('getTransactionsForCard: ${e.response}');
    } finally {
      isLoading.value = false;
    }
    return transactions;
  }
}
