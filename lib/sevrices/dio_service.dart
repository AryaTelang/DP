import 'package:bachat_cards/sevrices/shared_prefs.dart';
import 'package:dio/dio.dart';

class ApiService {
  static late Dio dio;

  static Dio getDioInstance() {
    dio = Dio(BaseOptions(
        headers: {'Authorization': 'Bearer ${SharedPrefs.getToken()}'}));
    return dio;
  }
}
