import 'package:bachat_cards/Constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../models/transaction.dart';

class TransactionsController extends GetxController {
  List<Transaction> transactions = <Transaction>[].obs;
  
  Future<List<Transaction>> getTransactions(Dio dio) async {
    transactions.clear();
    try {
      final response =
          await dio.get('${Constants.url}/mbc/v1/cashback/transaction');
      if (response.data['result'].isNotEmpty) {
        if (response.data['result'][0]['transactions'].isNotEmpty) {
          for (int i = 0;
              i < response.data['result'][0]['transactions'].length;
              i++) {
            transactions.add(Transaction.fromJson(
                response.data['result'][0]['transactions'][i]));
          }
        }
      }
    } on DioError catch (e) {
      debugPrint('getTransactions: ${e.response}');
      if (e.response!.data['message'] != 'Not found') {
        throw Exception();
      }
    } catch (e) {
      debugPrint('getTransaction$e');
    }
    return transactions;
  }
}
