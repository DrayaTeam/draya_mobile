import "package:dio/dio.dart";
import "package:draya_mobile/core/networking/api_constants.dart";
import "package:draya_mobile/features/auth/data/models/auth_response_model.dart";
import "package:draya_mobile/features/auth/data/models/login_request_model.dart";
import "package:draya_mobile/features/auth/data/models/refresh_token_request_model.dart";
import "package:draya_mobile/features/auth/data/models/register_student_request_model.dart";
import "package:draya_mobile/features/auth/data/models/register_teacher_request_model.dart";
import "package:draya_mobile/features/auth/data/models/user_profile_model.dart";
import "package:draya_mobile/features/auth/data/source/auth_api_constants.dart";
import "package:retrofit/retrofit.dart";
part "auth_api_service.g.dart";

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class AuthApiService {
  factory AuthApiService(Dio dio) = _AuthApiService;

  @POST(AuthApiConstants.login)
  Future<AuthResponseModel> login(@Body() LoginRequestModel request);

  @POST(AuthApiConstants.refreshToken)
  Future<AuthResponseModel> refreshToken(
    @Body() RefreshTokenRequestModel refreshTokenRequestModel,
  );

  @POST(AuthApiConstants.teacherRegister)
  Future<AuthResponseModel> registerTeacher(
    @Body() RegisterTeacherRequestModel request,
  );

  @POST(AuthApiConstants.studentRegister)
  Future<AuthResponseModel> registerStudent(
    @Body() RegisterStudentRequestModel request,
  );

  @GET(AuthApiConstants.me)
  Future<UserProfileModel> getCurrentUserProfile();
}
