import 'package:bachat_cards/controllers/cards_controller.dart';
import 'package:bachat_cards/controllers/dashboard_controller.dart';
import 'package:bachat_cards/controllers/home_screen_controller.dart';
import 'package:bachat_cards/controllers/login_screen_controler.dart';
import 'package:bachat_cards/controllers/offers_screen_controller.dart';
import 'package:bachat_cards/controllers/onboarding_screen_controller.dart';
import 'package:bachat_cards/controllers/post_login_screen_controller.dart';
import 'package:bachat_cards/controllers/redeem_points_screen_controller.dart';
import 'package:bachat_cards/controllers/rewards_screen_controller.dart';
import 'package:get/instance_manager.dart';

class InitialBindigs extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostLoginScreenController>(() => PostLoginScreenController());
    Get.lazyPut<OnboardingScreenController>(() => OnboardingScreenController());
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<RedeemPointsScreenController>(
        () => RedeemPointsScreenController());
    Get.lazyPut<RewardsScreenController>(() => RewardsScreenController());
    Get.lazyPut<OffersController>(() => OffersController());
    Get.lazyPut<HomeScreenController>(() => HomeScreenController());
    Get.lazyPut<CardsController>(() => CardsController());
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
