import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:bachat_cards/controllers/login_screen_controler.dart';
import 'package:bachat_cards/screens/auth_screens/login_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Constants/constants.dart';
import '../screens/terms_conditions_screen.dart';

class SignUpScreenController extends GetxController {
  late TapGestureRecognizer tapGestureRecognizer;
  late TextEditingController phoneTextEditingController;
  late TextEditingController emailController;

  String earnestUserId = '';
  String userSub = '';

  var termsCheck = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    phoneTextEditingController = TextEditingController();
    emailController = TextEditingController();
    tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        termsCheck.value = true;
        Get.to(() => const TermsConditionsScreen());
      };
    super.onInit();
  }

  @override
  void onClose() {
    tapGestureRecognizer.dispose();
    emailController.dispose();
    phoneTextEditingController.dispose();
    super.onClose();
  }

  Future<void> startUserSignUp(
      String phoneNumber, String email, Dio dio) async {
    try {
      await dio.get('${Constants.url}/um/v1/validateUser',
          queryParameters: {'mobile_no': phoneNumber, 'email': email});
      Get.snackbar('Info', 'User already exists. Please Login');
      isLoading.value = false;
      Get.off(() => LoginScreen());
    } on DioError catch (e) {
      if (e.response!.data['error_info']['error_code'] != 200) {
        createUserInEarnest(phoneNumber, email, dio);
      }
    }
  }

  Future<void> createUserInEarnest(
      String phoneNumber, String email, Dio dio) async {
    try {
      final response =
          await dio.post('${Constants.url}/um/v1/updateProfile', data: {
        'control_info': {'operator_id': '3'},
        'user_info': {
          'device_id': '',
          'mobile_no': phoneNumber,
          'email': email,
          'reward_balance': 0,
          'user_status': '',
          'gender': '',
          'age_group': 0,
          'birth_year': 0,
          'occupation': '',
          'first_name': '',
          'last_name': '',
          'maritial_status': '',
          'pref_lang': '',
          'city': '', // USE Location to fill this information
          'pin_code': '',
          'country': 'IND',
        }
      });
      earnestUserId = response.data['user_id'];
      createUserInCognito(phoneNumber, email, dio);
    } on DioError catch (e) {
      if (e.response!.data['error_info']['error_code'] != 200) {
        isLoading.value = false;
        Get.snackbar('Error!', e.message ?? '');
      }
    }
  }

  Future<void> createUserInCognito(
      String phoneNumber, String email, Dio dio) async {
    CognitoUserPool userPool =
        CognitoUserPool('ap-south-1_ikAg1NHq5', '3kmneke95d9nl5ka49qm6ogfpv');
    CognitoUserPoolData data;
    try {
      data = await userPool.signUp(phoneNumber, 'IlijKsms1999',
          userAttributes: [
            AttributeArg(name: 'phone_number', value: phoneNumber)
          ]);
      userSub = data.userSub!;
      registerUser(userSub, earnestUserId, phoneNumber, email, dio);
    } on UsernameExistsException catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'User already exists.');
      debugPrint('UsernameExistsException : $e');
    } on AuthException catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.message);
      debugPrint('UsernameExistsException:${e.message}');
    }
  }

  Future<void> registerUser(String userSub, String earnestId,
      String phoneNumber, String email, Dio dio) async {
    try {
      await dio.post('${Constants.url}/mb-be/user/register', data: {
        'cognitoId': userSub,
        'earnestId': earnestUserId,
        'mobileNo': phoneNumber,
        'email': email
      });
      await Get.find<LoginController>().login(phoneNumber, dio);
      isLoading.value = false;
    } on DioError catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.message ?? '');
    }
  }
}
