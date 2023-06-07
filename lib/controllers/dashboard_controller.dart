import 'package:bachat_cards/models/transaction.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../Constants/constants.dart';

class DashboardController extends GetxController {
  RxString selectedYear = DateTime.now().year.toString().obs;
  var transactions = <Transaction>[].obs;
  var yearlyTransactions = <Transaction>[].obs;
  var selectedCardType = SelectedCardType.onceLoadable.obs;
  var multiLoadableCardTransactions = <Transaction>[].obs;
  var multiLoadableCardYearlyTransactions = <Transaction>[].obs;
  var multiLoadableSelectedYear = DateTime.now().year.toString().obs;
  var monthlyTransactions = <Transaction>[].obs;
  var multiLoadableMonthlyTransactions = <Transaction>[].obs;
  RxBool isShowMonthlyTransactions = false.obs;
  RxBool isShowMultiLoadableCardMonthlyTransactions = false.obs;
  late PageController cardsPageController;
  var currentCard = 1.obs;
  var isLoading = false.obs;

  Future<List<Transaction>> getTransactionsForCard(
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
    }
    getYearlyTransaction(selectedYear.value);
    return transactions;
  }

  Future<List<Transaction>> getTransactionsForMultiLoadableCard(
      String cardReferenceNumber, Dio dio) async {
    isLoading.value = true;
    multiLoadableCardTransactions.clear();
    try {
      final response = await dio.get('${Constants.url}/mbc/v1/transaction',
          queryParameters: {'cardReferenceNumber': cardReferenceNumber});
      for (int i = 0; i < response.data['transactionDetailList'].length; i++) {
        multiLoadableCardTransactions.add(
            Transaction.fromJson(response.data['transactionDetailList'][i]));
      }
    } on DioError catch (e) {
      debugPrint('getTransactionsForCard: ${e.response}');
    }
    getYearlyMultiLoadableCardTransaction(multiLoadableSelectedYear.value);
    return multiLoadableCardTransactions;
  }

  List<Transaction> getYearlyMultiLoadableCardTransaction(String year) {
    multiLoadableCardYearlyTransactions.clear();
    for (Transaction t in multiLoadableCardTransactions) {
      final String transactionYear =
          DateFormat.y().format(DateTime.parse(t.transactionDate!));
      if (transactionYear == year) {
        multiLoadableCardYearlyTransactions.add(t);
      }
    }
    isLoading.value = false;
    return multiLoadableCardYearlyTransactions;
  }

  List<Transaction> getYearlyTransaction(String year) {
    yearlyTransactions.clear();
    for (Transaction t in transactions) {
      final String transactionYear =
          DateFormat.y().format(DateTime.parse(t.transactionDate!));
      if (transactionYear == year) {
        yearlyTransactions.add(t);
      }
    }
    isLoading.value = false;
    return yearlyTransactions;
  }

  double getMonthlyTotal(String month) {
    double monthlyTotal = 0.0;
    for (Transaction t in yearlyTransactions) {
      String transactionMonth =
          DateFormat.LLL().format(DateTime.parse(t.transactionDate!));
      if (transactionMonth.toLowerCase() == month.toLowerCase()) {
        monthlyTotal =
            monthlyTotal + double.parse(t.transactionAmount ?? '0.0');
      }
    }
    return monthlyTotal;
  }

  double getMultiLoadbaleMonthlyTotal(String month) {
    double monthlyTotal = 0.0;
    for (Transaction t in multiLoadableCardYearlyTransactions) {
      String transactionMonth =
          DateFormat.LLL().format(DateTime.parse(t.transactionDate!));
      if (transactionMonth.toLowerCase() == month.toLowerCase()) {
        monthlyTotal =
            monthlyTotal + double.parse(t.transactionAmount ?? '0.0');
      }
    }
    return monthlyTotal;
  }

  void getMultiLoadableMonthlyTransactions(String month) {
    for (Transaction t in multiLoadableCardYearlyTransactions) {
      String transactionMonth =
          DateFormat.LLL().format(DateTime.parse(t.transactionDate!));
      if (transactionMonth.toLowerCase() == month.toLowerCase()) {
        multiLoadableMonthlyTransactions.add(t);
      }
    }
    debugPrint(multiLoadableMonthlyTransactions.length.toString());
  }

  void getMonthlyTransactions(String month) {
    monthlyTransactions.clear();
    for (Transaction t in yearlyTransactions) {
      String transactionMonth =
          DateFormat.LLL().format(DateTime.parse(t.transactionDate!));
      if (transactionMonth.toLowerCase() == month.toLowerCase()) {
        monthlyTransactions.add(t);
      }
    }
  }

  String getMonth(int index) {
    String month = '';
    switch (index) {
      case 0:
        month = 'Jan';
        break;
      case 1:
        month = 'Feb';
        break;
      case 2:
        month = 'Mar';
        break;
      case 3:
        month = 'Apr';
        break;
      case 4:
        month = 'May';
        break;
      case 5:
        month = 'Jun';
        break;
      case 6:
        month = 'Jul';
        break;
      case 7:
        month = 'Aug';
        break;
      case 8:
        month = 'Sep';
        break;
      case 9:
        month = 'Oct';
        break;
      case 10:
        month = 'Nov';
        break;
      case 11:
        month = 'Dec';
        break;
    }
    return month;
  }
}
