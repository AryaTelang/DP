import 'package:bachat_cards/screens/card_screens/web_view.dart';
import 'package:bachat_cards/theme/theme.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Constants/constants.dart';
import '../controllers/cards_controller.dart';

class CardWidget extends StatefulWidget {
  const CardWidget(
      {super.key,
      required this.cardsController,
      required this.maskedCardNumber,
      required this.cardReferenceNumber,
      this.cardUrl,
      this.cardType,
      this.index,
      required this.dio});

  final CardsController cardsController;
  final String maskedCardNumber;
  final String cardReferenceNumber;
  final String? cardUrl;
  final CardType? cardType;
  final Dio dio;
  final int? index;

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  bool isLoading = false;
  String balance = '0';
  bool isGetBalanceClicked = false;

  Future<String> getCardBalance(String cardReferenceNumber) async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
      try {
        final response = await widget.dio.get(
            '${Constants.url}/mbc/v1/card/balance',
            queryParameters: {'referenceId': cardReferenceNumber});
        setState(() {
          balance = response.data['availableAmount'].toString();
          isGetBalanceClicked = true;
        });
      } on DioError catch (e) {
        debugPrint('Get balance error : ${e.response}');
        Get.snackbar('Error',
            "Some error occured while trying to get balance. Please try again later");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
    return balance;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.cardUrl == null
          ? null
          : () => Get.to(() => WebView(url: 'https://${widget.cardUrl}')),
      child: AspectRatio(
        aspectRatio: 11 / 16,
        child: Container(
          margin: const EdgeInsets.only(
            left: 16,
          ),
          decoration: BoxDecoration(
            image: const DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/cardBackground.png')),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 13),
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FittedBox(
                    child: Text(
                      widget.maskedCardNumber,
                      softWrap: false,
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(100, 30),
                        backgroundColor: const Color(0xffF4F4F4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        if (!isGetBalanceClicked) {
                          getCardBalance(widget.cardReferenceNumber);
                        } else {
                          setState(() {
                            isGetBalanceClicked = !isGetBalanceClicked;
                          });
                        }
                      },
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: primaryColor,
                                strokeWidth: 2,
                              ))
                          : !isLoading && !isGetBalanceClicked
                              ? const Text(
                                  'Balance',
                                  style: TextStyle(color: Colors.black),
                                )
                              : Text(
                                  '\u{20B9} $balance',
                                  style: const TextStyle(color: Colors.black),
                                ))
                ]),
          ),
        ),
      ),
    );
  }
}
