import 'package:flutter/material.dart';

enum CardType { onceReload, multiReload, multiReloadAddAmount }

enum RedeemCuponSelectedTab { process, matrix, tc }

enum KYCType{min,max}

enum TransactionType {
  credit('1'),
  debit('2'),
  cashback('4'),
  voidCase('9'),
  refund('17'),
  reversal('18'),
  surchargeDebit('19'),
  surchargeVoid('20'),
  surchargeReversal('21');

  const TransactionType(this.value);
  final String value;
}

enum SelectedCardType { onceLoadable, multiLoadable }

enum DetailsType { onceLoadable, multiLoadable, voucher }

class Constants {
  static const String url = 'https://staging.meribachat.in';
  static const String token = 'token';
  static const String earnestUserId = 'earnestUserId';
  static const String phone = 'phone';
  static const String isNewAppInstall = 'install';
  static const String carouselKey = 'carousel';
  static const String forceUpdateKey = 'force_update';
  static const String updateAvailableKey = 'update_available';
  static const List<Color> colors = [
    Color(0xFF616161),
    Color(0xFF6655C0),
    Color(0xFFFFCB3D)
  ];
}
