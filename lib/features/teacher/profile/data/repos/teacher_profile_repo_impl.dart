import "package:draya_mobile/core/networking/api_error_handler.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/profile/data/models/teacher_model.dart";
import "package:draya_mobile/features/teacher/profile/data/source/teacher_profile_api_service.dart";
import "package:draya_mobile/features/teacher/profile/domain/repos/teacher_profile_repo.dart";

class TeacherProfileRepoImpl implements TeacherProfileRepo {
  final TeacherProfileApiService _teacherProfileApiService;

  TeacherProfileRepoImpl(this._teacherProfileApiService);

  @override
  Future<ApiResult<TeacherModel>> getTeacherProfile() async {
    try {
      final response = await _teacherProfileApiService.getTeacherProfile();

      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
