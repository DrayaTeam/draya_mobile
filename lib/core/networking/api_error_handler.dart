import 'package:dio/dio.dart';

import 'api_error_model.dart';

class ErrorHandler {
  static ApiErrorModel handle(dynamic error) {
    final statusCode = error.response?.statusCode;
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionError:
          return ApiErrorModel(
            error: ErrorModel(
              message: "No internet connection",
              code: statusCode.toString(),
            ),
            retry: true,
          );
        case DioExceptionType.cancel:
          return ApiErrorModel(
            error: ErrorModel(
              message: "Request to the server was cancelled",
              code: statusCode.toString(),
            ),
            retry: true,
          );
        case DioExceptionType.connectionTimeout:
          return ApiErrorModel(
            error: ErrorModel(
              message: "Connection timeout",
              code: statusCode.toString(),
            ),
            retry: true,
          );
        case DioExceptionType.unknown:
          return ApiErrorModel(
            error: ErrorModel(
              message:
                  "Connection to the server failed due to internet connection",
              code: statusCode.toString(),
            ),
            retry: true,
          );
        case DioExceptionType.receiveTimeout:
          return ApiErrorModel(
            error: ErrorModel(
              message: "Receive timeout in connection with the server",
              code: statusCode.toString(),
            ),
            retry: true,
          );
        case DioExceptionType.badResponse:
          return _handleError(error.response?.data, statusCode);
        case DioExceptionType.sendTimeout:
          return ApiErrorModel(
            error: ErrorModel(
              message: "Send timeout in connection with the server",
              code: statusCode.toString(),
            ),
            retry: true,
          );
        default:
          return ApiErrorModel(
            error: ErrorModel(
              message: "Something went wrong",
              code: statusCode.toString(),
            ),
          );
      }
    } else {
      return ApiErrorModel(
        error: ErrorModel(
          message: "Unknown error occurred",
          code: statusCode.toString(),
        ),
        retry: true,
      );
    }
  }
}

ApiErrorModel _handleError(dynamic data, int? statusCode) {
  try {
    return ApiErrorModel(
      error: ErrorModel(
        message: data['error']['message'],
        code: statusCode.toString(),
      ),
    );
  } catch (e) {
    return ApiErrorModel(
      error: ErrorModel(
        message: "Something went wrong",
        code: statusCode.toString(),
      ),
    );
  }
}
