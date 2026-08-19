import "package:dio/dio.dart";

import "api_error_model.dart";

abstract final class ErrorHandler {
  static ApiErrorModel handle(Object error) {
    if (error is! DioException) {
      return const ApiErrorModel(
        error: ErrorModel(
          message: "An unexpected error occurred",
        ),
      );
    }

    final statusCode = error.response?.statusCode;

    switch (error.type) {
      case DioExceptionType.connectionError:
        return _networkError(
          message: "No internet connection",
          statusCode: statusCode,
        );

      case DioExceptionType.connectionTimeout:
        return _networkError(
          message: "Connection timeout",
          statusCode: statusCode,
        );

      case DioExceptionType.sendTimeout:
        return _networkError(
          message: "Request timeout while sending data to the server",
          statusCode: statusCode,
        );

      case DioExceptionType.receiveTimeout:
        return _networkError(
          message: "Request timeout while receiving data from the server",
          statusCode: statusCode,
        );

      case DioExceptionType.badResponse:
        return _handleError(
          error.response?.data,
          statusCode,
        );

      case DioExceptionType.cancel:
        return ApiErrorModel(
          error: ErrorModel(
            message: "Request was cancelled",
            code: _statusCode(statusCode),
          ),
          retry: false,
        );

      case DioExceptionType.badCertificate:
        return ApiErrorModel(
          error: ErrorModel(
            message: "Could not establish a secure connection to the server",
            code: _statusCode(statusCode),
          ),
          retry: false,
        );

      case DioExceptionType.unknown:
        return ApiErrorModel(
          error: ErrorModel(
            message: "An unexpected network error occurred",
            code: _statusCode(statusCode),
          ),
          retry: true,
        );
      case DioExceptionType.transformTimeout:
        return _networkError(
          message: "Request processing timed out",
          statusCode: statusCode,
        );
    }
  }

  static ApiErrorModel _handleError(
    Object data,
    int? statusCode,
  ) {
    final serverMessage = _extractMessage(data);

    return ApiErrorModel(
      error: ErrorModel(
        message: serverMessage ?? _defaultMessage(statusCode),
        code: _statusCode(statusCode),
      ),
      retry: _shouldRetry(statusCode),
    );
  }

  static ApiErrorModel _networkError({
    required String message,
    required int? statusCode,
  }) {
    return ApiErrorModel(
      error: ErrorModel(
        message: message,
        code: _statusCode(statusCode),
      ),
      retry: true,
    );
  }

  static String? _extractMessage(Object data) {
    if (data is! Map) {
      return null;
    }

    final error = data["error"];

    if (error is Map) {
      final message = error["message"];

      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }
    }

    return null;
  }

  static bool _shouldRetry(int? statusCode) {
    if (statusCode == null) {
      return true;
    }

    // Request timeout.
    if (statusCode == 408) {
      return true;
    }

    // Too many requests. Usually retry after a delay.
    if (statusCode == 429) {
      return true;
    }

    // Server-side errors.
    return statusCode >= 500 && statusCode <= 599;
  }

  static String? _statusCode(int? statusCode) {
    return statusCode?.toString();
  }

  static String _defaultMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return "Invalid request";

      case 401:
        return "Unauthorized request";

      case 403:
        return "You do not have permission to perform this action";

      case 404:
        return "The requested resource was not found";

      case 408:
        return "Request timeout";

      case 409:
        return "Request conflict";

      case 422:
        return "The submitted data is invalid";

      case 429:
        return "Too many requests. Please try again later";

      case 500:
        return "Internal server error";

      case 502:
        return "Bad gateway";

      case 503:
        return "Service unavailable";

      case 504:
        return "Gateway timeout";

      default:
        return "Something went wrong";
    }
  }
}
