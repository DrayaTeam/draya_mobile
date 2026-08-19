import "package:dio/dio.dart";
import "package:draya_mobile/core/helpers/app_token_helper.dart";
import "package:draya_mobile/features/auth/data/models/refresh_token_request_model.dart";
import "package:draya_mobile/features/auth/data/source/auth_api_constants.dart";
import "package:draya_mobile/features/auth/data/source/auth_api_service.dart";

class AuthInterceptor extends QueuedInterceptor {
  final Dio dio;
  final AuthApiService refreshAuthApiService;
  Future<String?>? _refreshFuture;

  AuthInterceptor({
    required this.dio,
    required this.refreshAuthApiService,
  });

  bool _isAuthRequest(RequestOptions options) {
    final path = options.path;

    return path.contains(AuthApiConstants.login) ||
        path.contains(AuthApiConstants.studentRegister) ||
        path.contains(AuthApiConstants.teacherRegister) ||
        path.contains(AuthApiConstants.refreshToken);
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isAuthRequest(options)) {
      handler.next(options);
      return;
    }

    final accessToken = await AppTokenHelper.getAccessToken();

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $accessToken";
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    if (_isAuthRequest(err.requestOptions)) {
      handler.next(err);
      return;
    }

    final newAccessToken = await _refreshAccessToken();

    if (newAccessToken == null) {
      await _handleRefreshFailure();
      handler.next(err);
      return;
    }

    final requestOptions = err.requestOptions;

    requestOptions.headers["Authorization"] = "Bearer $newAccessToken";

    try {
      final response = await dio.fetch(requestOptions);

      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<String?> _refreshAccessToken() {
    if (_refreshFuture != null) {
      return _refreshFuture!;
    }

    _refreshFuture = _performRefresh();

    return _refreshFuture!.whenComplete(() {
      _refreshFuture = null;
    });
  }

  Future<String?> _performRefresh() async {
    final refreshToken = await AppTokenHelper.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    try {
      final response = await refreshAuthApiService.refreshToken(
        RefreshTokenRequestModel(
          refreshToken: refreshToken,
        ),
      );

      final newAccessToken = response.accessToken;
      final newRefreshToken = response.refreshToken;

      if (newAccessToken.isEmpty || newRefreshToken.isEmpty) {
        return null;
      }

      await AppTokenHelper.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );

      return newAccessToken;
    } on DioException {
      return null;
    }
  }

  Future<void> _handleRefreshFailure() async {
    await AppTokenHelper.clearTokens();
  }
}
