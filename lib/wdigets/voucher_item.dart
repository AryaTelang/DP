import 'package:bachat_cards/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class VoucherItem extends StatelessWidget {
  const VoucherItem({
    super.key,
    required this.amount,
    required this.code,
    required this.expiryDate,
    required this.logo,
    required this.brandName,
    required this.pin,
    required this.purchaseDate,
  });

  final String brandName;
  final String? logo;
  final String amount;
  final String purchaseDate;
  final String expiryDate;
  final String pin;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 40),
                        child: logo == null
                            ? Image.asset(
                                'assets/images/logo.png',
                                height: 60,
                                width: 100,
                              )
                            : CachedNetworkImage(
                                imageUrl: logo ?? '',
                                height: 60,
                                width: 100,
                                fit: BoxFit.contain,
                              ),
                      ),
                    ),
                    Text(
                      brandName,
                      style: poppinsSemiBold18,
                    ),
                    Text(
                      '\u{20B9} $amount',
                      style: poppinsSemiBold18,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    if (purchaseDate != '')
                      _detailsText(
                          'Purchase Date: ${DateFormat('dd MMM yyyy').format(DateTime.parse(purchaseDate).toLocal())}',
                          context),
                    _detailsText('Expiry: $expiryDate', context),
                    Row(
                      children: [
                        Text(
                          'Code: $code',
                          style: poppinsMedium14,
                        ),
                        IconButton(
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: code))
                                  .then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        duration: Duration(milliseconds: 500),
                                        content:
                                            Text("Code copied to clipboard")));
                              });
                            },
                            icon: const Icon(Icons.copy, size: 17))
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Pin: $pin',
                          style: poppinsMedium14,
                        ),
                        IconButton(
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: pin))
                                  .then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        duration: Duration(milliseconds: 500),
                                        content:
                                            Text("Pin copied to clipboard")));
                              });
                            },
                            icon: const Icon(Icons.copy, size: 17))
                      ],
                    )
                  ],
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  _detailsText(String text, BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14),
    );
  }
}
