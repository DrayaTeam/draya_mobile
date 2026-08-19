import "package:dio/dio.dart";
import "package:draya_mobile/core/networking/interceptors/auth_interceptor.dart";
import "package:draya_mobile/features/auth/data/source/auth_api_service.dart";
import "package:pretty_dio_logger/pretty_dio_logger.dart";

abstract final class DioFactory {
  static Dio? dio;

  static Future<Dio> getDio() async {
    Duration timeOut = const Duration(seconds: 60);

    if (dio != null) {
      return dio!;
    }

    final mainDio = Dio(
      BaseOptions(
        connectTimeout: timeOut,
        receiveTimeout: timeOut,
        sendTimeout: timeOut,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      ),
    );

    final refreshDio = Dio(
      BaseOptions(
        connectTimeout: timeOut,
        receiveTimeout: timeOut,
        sendTimeout: timeOut,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      ),
    );

    final refreshAuthApiService = AuthApiService(refreshDio);

    mainDio.interceptors.add(
      AuthInterceptor(
        dio: mainDio,
        refreshAuthApiService: refreshAuthApiService,
      ),
    );

    mainDio.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
      ),
    );

    dio = mainDio;
    return dio!;
  }
}
