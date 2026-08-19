import "package:draya_mobile/core/networking/api_error_handler.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/auth/data/models/auth_response_model.dart";
import "package:draya_mobile/features/auth/data/models/login_request_model.dart";
import "package:draya_mobile/features/auth/data/models/refresh_token_request_model.dart";
import "package:draya_mobile/features/auth/data/models/register_student_request_model.dart";
import "package:draya_mobile/features/auth/data/models/register_teacher_request_model.dart";
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
}
