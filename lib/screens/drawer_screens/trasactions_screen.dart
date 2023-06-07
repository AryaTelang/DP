import 'package:bachat_cards/appbar/appbar.dart';
import 'package:bachat_cards/controllers/transactions_controller.dart';
import 'package:bachat_cards/theme/theme.dart';
import 'package:bachat_cards/wdigets/transaction_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../sevrices/shared_prefs.dart';

class TransactionsScreen extends StatelessWidget {
  TransactionsScreen({super.key});

  final transactionsController = Get.put(TransactionsController());
  final Dio dio = Dio(BaseOptions(
      headers: {'Authorization': 'Bearer ${SharedPrefs.getToken()}'}));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SharedAppBar(
          appBar: AppBar(),
          title: Text(
            'My Transactions',
            style: poppinsSemiBold18.copyWith(color: Colors.black),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return transactionsController.getTransactions(dio);
          },
          child: SafeArea(
            child: FutureBuilder(
              future: transactionsController.getTransactions(dio),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return LayoutBuilder(
                    builder: (context, constraints) => SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                            minWidth: constraints.maxWidth),
                        child: const Center(
                          child: Text('Some error occured'),
                        ),
                      ),
                    ),
                  );
                }
                if (snapshot.hasData &&
                    transactionsController.transactions.isNotEmpty) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: const [
                            Expanded(
                                flex: 1,
                                child: Text(
                                  'Sr. No.',
                                  textAlign: TextAlign.center,
                                )),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  'Date',
                                  textAlign: TextAlign.center,
                                )),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Amount',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  'Type',
                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: transactionsController.transactions.length,
                          itemBuilder: ((context, index) => TransactionWidget(
                              id: '${index + 1}',
                              date: transactionsController
                                      .transactions[index].transactionDate ??
                                  '',
                              amount: transactionsController
                                      .transactions[index].transactionAmount ??
                                  '',
                              type: transactionsController
                                      .transactions[index].transactionType ??
                                  '')),
                        ),
                      )
                    ],
                  );
                }
                if (snapshot.hasData &&
                    transactionsController.transactions.isEmpty) {
                  return LayoutBuilder(
                    builder: (context, constraints) => SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                            minWidth: constraints.maxWidth),
                        child: const Center(
                          child:
                              Text('You don\'t have any transactions yet!!!'),
                        ),
                      ),
                    ),
                  );
                }
                return const Center(
                  child: Text('None'),
                );
              },
            ),
          ),
        ));
  }
}
