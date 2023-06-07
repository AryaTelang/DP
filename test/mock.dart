import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:bachat_cards/sevrices/shared_prefs.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';

class MockCognitoUser extends Mock implements CognitoUser {}

class MockCognitoUserPool extends Mock implements CognitoUserPool {
  CognitoUser getUser(String username) {
    return MockCognitoUser();
  }
}

class MockCognitoUserSession extends Mock implements CognitoUserSession {}

class MockApiService extends Mock implements Dio {}

class MockSharedPrefs extends Mock implements SharedPrefs {}
