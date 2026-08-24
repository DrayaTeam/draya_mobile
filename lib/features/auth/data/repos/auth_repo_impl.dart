import "package:draya_mobile/core/constants/app_shared_pref_keys.dart";
import "package:draya_mobile/core/helpers/app_shared_pref_helper.dart";
import "package:draya_mobile/core/helpers/app_token_helper.dart";
import "package:draya_mobile/core/networking/api_error_handler.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/auth/data/models/auth_response_model.dart";
import "package:draya_mobile/features/auth/data/models/confirm_password_reset_model.dart";
import "package:draya_mobile/features/auth/data/models/login_request_model.dart";
import "package:draya_mobile/features/auth/data/models/refresh_token_request_model.dart";
import "package:draya_mobile/features/auth/data/models/register_student_request_model.dart";
import "package:draya_mobile/features/auth/data/models/register_teacher_request_model.dart";
import "package:draya_mobile/features/auth/data/models/request_password_reset_model.dart";
import "package:draya_mobile/features/auth/data/models/user_profile_model.dart";
import "package:draya_mobile/features/auth/data/source/auth_api_service.dart";
import "package:draya_mobile/features/auth/domain/repos/auth_repo.dart";

class AuthRepositoryImpl implements AuthRepo {
  final AuthApiService _authApiService;

  AuthRepositoryImpl(this._authApiService);

  @override
  Future<ApiResult<AuthResponseModel>> login(
    LoginRequestModel loginRequestModel,
  ) async {
    try {
      final response = await _authApiService.login(loginRequestModel);

      await _saveAuthTokens(authResponseModel: response);

      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<AuthResponseModel>> refreshToken(
    RefreshTokenRequestModel refreshTokenRequestModel,
  ) async {
    try {
      final response = await _authApiService.refreshToken(
        refreshTokenRequestModel,
      );

      await _saveAuthTokens(authResponseModel: response);

      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<AuthResponseModel>> registerStudent(
    RegisterStudentRequestModel registerStudentRequestModel,
  ) async {
    try {
      final response = await _authApiService.registerStudent(
        registerStudentRequestModel,
      );

      await _saveAuthTokens(authResponseModel: response);

      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<AuthResponseModel>> registerTeacher(
    RegisterTeacherRequestModel registerTeacherRequestModel,
  ) async {
    try {
      final response = await _authApiService.registerTeacher(
        registerTeacherRequestModel,
      );

      await _saveAuthTokens(authResponseModel: response);

      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<UserProfileModel>> getCurrentUserProfile() async {
    try {
      final response = await _authApiService.getCurrentUserProfile();

      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  Future<void> _saveAuthTokens({
    required AuthResponseModel authResponseModel,
  }) async {
    await AppTokenHelper.saveTokens(
      accessToken: authResponseModel.accessToken,
      refreshToken: authResponseModel.refreshToken,
    );

    final role = authResponseModel.user?.role;

    if (role != null && role.isNotEmpty) {
      await AppSharedPrefHelper.setData(
        AppSharedPrefKeys.userRole,
        role,
      );
    }
  }

  @override
  Future<ApiResult<void>> requestPasswordReset({
    required RequestPasswordResetModel requestPasswordResetModel,
  }) async {
    try {
      final response = await _authApiService.requestPasswordReset(
        requestPasswordResetModel,
      );

      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<void>> confirmPasswordReset({
    required ConfirmPasswordResetModel confirmPasswordResetModel,
  }) async {
    try {
      final response = await _authApiService.confirmPasswordReset(
        confirmPasswordResetModel,
      );

      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
