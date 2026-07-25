import 'package:dio/dio.dart';

import 'api_error_model.dart';

class ErrorHandler {
  static ApiErrorModel handle(dynamic error) {
    final statusCode = error.response?.statusCode;
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionError:
          return ApiErrorModel(
            message: "No internet connection",
            retry: true,
            statusCode: statusCode.toString(),
          );
        case DioExceptionType.cancel:
          return ApiErrorModel(
            message: "Request to the server was cancelled",
            retry: true,
            statusCode: statusCode.toString(),
          );
        case DioExceptionType.connectionTimeout:
          return ApiErrorModel(
            message: "Connection timeout",
            retry: true,
            statusCode: statusCode.toString(),
          );
        case DioExceptionType.unknown:
          return ApiErrorModel(
            message:
                "Connection to the server failed due to internet connection",
            retry: true,
            statusCode: statusCode.toString(),
          );
        case DioExceptionType.receiveTimeout:
          return ApiErrorModel(
            message: "Receive timeout in connection with the server",
            retry: true,
            statusCode: statusCode.toString(),
          );
        case DioExceptionType.badResponse:
          return _handleError(error.response?.data, statusCode);
        case DioExceptionType.sendTimeout:
          return ApiErrorModel(
            message: "Send timeout in connection with the server",
            retry: true,
            statusCode: statusCode.toString(),
          );
        default:
          return ApiErrorModel(
            message: "Something went wrong",
            statusCode: statusCode.toString(),
          );
      }
    } else {
      return ApiErrorModel(
        message: "Unknown error occurred",
        retry: true,
        statusCode: statusCode.toString(),
      );
    }
  }
}

ApiErrorModel _handleError(dynamic data, int? statusCode) {
  try {
    return ApiErrorModel(
      message: data['message'],
      statusCode: statusCode.toString(),
    );
  } catch (e) {
    return ApiErrorModel(message: "Something went wrong");
  }
}
