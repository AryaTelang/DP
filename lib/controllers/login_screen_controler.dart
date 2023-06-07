import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:bachat_cards/screens/auth_screens/signup_screen.dart';
import 'package:bachat_cards/screens/post_login_screen.dart';
import 'package:bachat_cards/sevrices/shared_prefs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Constants/constants.dart';
import '../screens/auth_screens/verify_otp_screen.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  late TextEditingController phoneEditingController;
  late TapGestureRecognizer tapGestureRecognizer;
  late CognitoUser cognitoUser1;
  late TextEditingController otpController;
  String earnestToken = '';
  Dio dio = Dio();
  var isResendLoading = false.obs;

  @override
  void onInit() {
    tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        isResendLoading.value = true;
        if (phoneEditingController.text.length == 13) {
          login(phoneEditingController.text, dio);
        } else if (phoneEditingController.text.length == 10) {
          login('+91${phoneEditingController.text}', dio);
        }
      };
    phoneEditingController = TextEditingController();
    otpController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    phoneEditingController.dispose();
    tapGestureRecognizer.dispose();
    otpController.dispose();
  }

  Future<String> login(String number, Dio dio) async {
    try {
      final response = await dio.get('${Constants.url}/um/v1/validateUser',
          queryParameters: {'mobile_no': number, 'opertor_id': 6});
      SharedPrefs.saveUserEarnestId(response.data['user_id']);
      SharedPrefs.saveUserPhoneNumber(number);
      await requestOtp(number);
      return 'user Found';
    } on DioError catch (e) {
      isLoading.value = false;
      if (e.response != null) {
        debugPrint(e.response.toString());
        Get.snackbar('Error', e.response?.data['error_info']['error_text']);
        if (e.response?.data['error_info']['error_text']
            .contains('User not found')) {
          Get.to(() => SignupScreen());
        }
      }
      return 'User not found';
    }
  }

  Future<void> requestOtp(String number) async {
    cognitoUser1 = CognitoUser(number,
        CognitoUserPool('ap-south-1_ikAg1NHq5', '186t1d8bcrskhpgobnl1hfjlsf'));
    try {
      await cognitoUser1.initiateAuth(
        AuthenticationDetails(
          validationData: {'isBachatCards': 'True'},
          authParameters: [
            AttributeArg(
              name: 'phone_number',
              value: number,
            ),
            const AttributeArg(
              name: 'CHALLENGE_NAME',
              value: 'CUSTOM_CHALLENGE',
            )
          ],
        ),
      );
    } on CognitoUserCustomChallengeException catch (_) {
      Get.to(() => const VerifyOtpScreen());
      isLoading.value = false;
      isResendLoading.value = false;
    } on CognitoUserException catch (cognitoUserCustomChallengeException) {
      isLoading.value = false;
      isResendLoading.value = false;
      Get.snackbar('Error', cognitoUserCustomChallengeException.message ?? '');
    } on CognitoClientException catch (e) {
      isLoading.value = false;
      isResendLoading.value = false;
      if (e.message!.contains('User does not exist')) {
        Get.snackbar('Error', 'User does not exists. Please register first');
        Get.to(() => SignupScreen());
      }
    } catch (e) {
      isLoading.value = false;
      isResendLoading.value = false;
      Get.snackbar('Error', 'Some error occured. Please try again later.');
      debugPrint(e.toString());
    }
  }

  Future<void> verifyOtp(String otp, Dio dio) async {
    CognitoUserSession? session;
    try {
      session = await cognitoUser1.sendCustomChallengeAnswer(otp);
      loginUser(session!.idToken.jwtToken!, dio);
    } on CognitoClientException catch (e) {
      if (e.message != null && e.message!.contains('Invalid session')) {
        Get.back();
      }
      Get.snackbar('Error', e.message!);
      isLoading.value = false;
    } on CognitoUserCustomChallengeException catch (e) {
      debugPrint('verifyOtp cognito: ${e.message}');
      isLoading.value = false;
      Get.snackbar('Error', 'You have entered wrong otp!!');
      debugPrint(e.challengeName);
    } catch (e) {
      debugPrint('otp : $e');
      isLoading.value = false;
    }
  }

  Future<String> loginUser(String token, Dio dio) async {
    try {
      final result = await dio
          .post('${Constants.url}/mb-be/user/login', data: {'token': token});
      if (result.statusCode == 200) {
        earnestToken = result.data['token'];
        SharedPrefs.saveToken(earnestToken);
        isLoading.value = false;
        Get.offAll(() => const PostLoginScreen());
        return 'login';
      }
      return '';
    } on DioError catch (e) {
      debugPrint('Login User: ${e.message}');
      isLoading.value = false;
      Get.snackbar('Error', e.message ?? '');
      return 'not logged in';
    }
  }
}
