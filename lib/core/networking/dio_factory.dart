import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/app_shared_pref_keys.dart';
import '../helpers/app_shared_pref_helper.dart';

class DioFactory {
  DioFactory._();

  static Dio? dio;

  static Future<Dio> getDio() async {
    Duration timeOut = const Duration(seconds: 60);

    if (dio == null) {
      dio = Dio();
      dio!
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut;
      await addDioHeaders();
      addDioInterceptor();
      return dio!;
    } else {
      return dio!;
    }
  }

  static Future<void> addDioHeaders() async {
    String? token = await AppSharedPrefHelper.getSecuredString(
      AppSharedPrefKeys.userToken,
    );
    dio?.options.headers = {
      'Accept': 'application/json',
      'Authorization': token == '' ? '' : 'Bearer $token',
    };
  }

  static void setTokenIntoHeader(String token) {
    dio?.options.headers = {
      'Authorization': token == '' ? '' : 'Bearer $token',
    };
  }

  static void addDioInterceptor() {
    dio?.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
      ),
    );
  }
}
