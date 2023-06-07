import 'package:bachat_cards/Constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionWidget extends StatelessWidget {
  const TransactionWidget(
      {super.key,
      required this.id,
      required this.date,
      required this.amount,
      required this.type});

  final String id;
  final String date;
  final String amount;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: type == TransactionType.credit.value ||
              type == TransactionType.cashback.value ||
              type == TransactionType.refund.value ||
              type == TransactionType.reversal.value ||
              type == TransactionType.surchargeReversal.value
          ? const Color(0xffB3EACC).withOpacity(0.5)
          : type == TransactionType.debit.value ||
                  type == TransactionType.surchargeDebit.value
              ? const Color(0xffFFCFCF).withOpacity(0.7)
              : null,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 1,
            child: Text(id,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                softWrap: true),
          ),
          const SizedBox(
            width: 8,
          ),
          if (date != '')
            Expanded(
              flex: 1,
              child: Text(
                DateFormat('dd/MMM/yyyy')
                    .format(DateTime.parse(date).toLocal()),
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          if (date != '')
            const SizedBox(
              width: 8,
            ),
          Expanded(
            flex: 1,
            child: Text(
              amount,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            flex: 1,
            child: Text(
              type == TransactionType.credit.value
                  ? 'Credit'
                  : type == TransactionType.debit.value
                      ? 'Debit'
                      : type == TransactionType.cashback.value
                          ? 'Cashback'
                          : type == TransactionType.voidCase.value
                              ? 'Void'
                              : type == TransactionType.refund.value
                                  ? "Refund"
                                  : type == TransactionType.reversal.value
                                      ? 'Reversal'
                                      : type ==
                                              TransactionType
                                                  .surchargeDebit.value
                                          ? 'Surcharge Debit'
                                          : type ==
                                                  TransactionType
                                                      .surchargeVoid.value
                                              ? 'Surcharge Void'
                                              : type ==
                                                      TransactionType
                                                          .surchargeReversal
                                                          .value
                                                  ? 'Surcharge Reversal'
                                                  : '',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
