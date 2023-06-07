import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static Future logOffersSearch({required String offerName}) async =>
      await _analytics.logEvent(
          name: 'search_offer', parameters: {'offer_brand_name': offerName});

  static Future logVoucherSearch({required String voucherName}) async =>
      await _analytics.logEvent(
          name: 'voucher_search',
          parameters: {'voucher_brand_name': voucherName});

  static Future logVoucherRedeem(
          {required String amount,
          required String brandName,
          required String denomination,
          required String itemCategory,
          required String brandId}) async =>
      _analytics
          .logPurchase(currency: 'INR', value: double.parse(amount), items: [
        AnalyticsEventItem(
          currency: 'INR',
          itemBrand: brandName,
          itemCategory: itemCategory,
          itemId: brandId,
          price: double.parse(denomination),
        )
      ]);

  static Future logBuyCard({required String amount}) =>
      _analytics.logEvent(name: 'buy_card', parameters: {'amount': amount});

  static Future logCardReload({required String amount}) => _analytics.logEvent(
      name: 'reload_card_amount', parameters: {'reload_amount': amount});

  static Future logScreenName({required String screenName}) async =>
      await _analytics.logScreenView(screenName: screenName);

  static Future logRewardFilter({required String filter}) => _analytics
      .logEvent(name: 'reward_filter', parameters: {'filter_name': filter});

  static Future logOfferFilter({required String filter}) => _analytics
      .logEvent(name: 'offer_filter', parameters: {'offer_filter_name': filter});
}
