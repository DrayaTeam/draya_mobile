import "dart:io";

import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/profile/data/models/teacher_model.dart";
import "package:draya_mobile/features/teacher/profile/data/models/update_teacher_request_model.dart";

abstract class TeacherProfileRepo {
  Future<ApiResult<TeacherModel>> getTeacherProfile();
  Future<ApiResult<dynamic>> uploadProfilePicture(File file);
  Future<ApiResult<void>> updateTeacherProfile({
    required UpdateTeacherRequestModel updateTeacherRequestModel,
  });
}
