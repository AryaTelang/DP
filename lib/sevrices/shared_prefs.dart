import 'package:bachat_cards/Constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences _prefs;

  static Future<SharedPreferences> init() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  static String getToken() => _prefs.getString(Constants.token) ?? '';

  static Future<bool> saveToken(String token) async =>
      await _prefs.setString(Constants.token, token);

  static Future<bool> deleteToken() async =>
      await _prefs.remove(Constants.token);

  static String getUserEarnestId() =>
      _prefs.getString(Constants.earnestUserId) ?? '';

  static Future<bool> saveUserEarnestId(String userId) async =>
      await _prefs.setString(Constants.earnestUserId, userId);

  static Future<bool> deleteUserId() async =>
      await _prefs.remove(Constants.earnestUserId);

  static Future<bool> saveUserPhoneNumber(String phone) async =>
      await _prefs.setString(Constants.phone, phone);

  static Future<bool> deletePhone() async =>
      await _prefs.remove(Constants.phone);

  static String getPhoneNumber() => _prefs.getString(Constants.phone) ?? '';

  static Future<bool> setIsFirstInstalled() async =>
      await _prefs.setBool(Constants.isNewAppInstall, false);

  static bool getIsFirstInstalled() =>
      _prefs.getBool(Constants.isNewAppInstall) ?? true;
}
