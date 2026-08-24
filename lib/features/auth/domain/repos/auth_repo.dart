import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/auth/data/models/auth_response_model.dart";
import "package:draya_mobile/features/auth/data/models/confirm_password_reset_model.dart";
import "package:draya_mobile/features/auth/data/models/login_request_model.dart";
import "package:draya_mobile/features/auth/data/models/refresh_token_request_model.dart";
import "package:draya_mobile/features/auth/data/models/register_student_request_model.dart";
import "package:draya_mobile/features/auth/data/models/register_teacher_request_model.dart";
import "package:draya_mobile/features/auth/data/models/request_password_reset_model.dart";
import "package:draya_mobile/features/auth/data/models/user_profile_model.dart";

abstract class AuthRepo {
  Future<ApiResult<AuthResponseModel>> login(
    LoginRequestModel loginRequestModel,
  );

  Future<ApiResult<AuthResponseModel>> refreshToken(
    RefreshTokenRequestModel refreshTokenRequestModel,
  );

  Future<ApiResult<AuthResponseModel>> registerTeacher(
    RegisterTeacherRequestModel registerTeacherRequestModel,
  );

  Future<ApiResult<AuthResponseModel>> registerStudent(
    RegisterStudentRequestModel registerStudentRequestModel,
  );

  Future<ApiResult<UserProfileModel>> getCurrentUserProfile();

  Future<ApiResult<void>> requestPasswordReset({
    required RequestPasswordResetModel requestPasswordResetModel,
  });

  Future<ApiResult<void>> confirmPasswordReset({
    required ConfirmPasswordResetModel confirmPasswordResetModel,
  });
}
