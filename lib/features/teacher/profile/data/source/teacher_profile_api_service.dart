import "package:dio/dio.dart";
import "package:draya_mobile/core/networking/api_constants.dart";
import "package:draya_mobile/features/teacher/profile/data/models/teacher_model.dart";
import "package:draya_mobile/features/teacher/profile/data/source/teacher_profile_api_constants.dart";
import "package:retrofit/retrofit.dart";

part "teacher_profile_api_service.g.dart";

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class TeacherProfileApiService {
  factory TeacherProfileApiService(Dio dio) = _TeacherProfileApiService;

  @GET(TeacherProfileApiConstants.teacherProfile)
  Future<TeacherModel> getTeacherProfile();

  @POST(TeacherProfileApiConstants.uploadProfilePicture)
  @MultiPart()
  Future<dynamic> uploadProfilePicture(
    @Part(name: "file") MultipartFile file,
  );
}
