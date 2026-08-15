import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/student/profile/data/models/student_profile_model.dart';
import 'package:draya_mobile/features/student/profile/data/models/update_student_profile_request_model.dart';

abstract class StudentProfileRepo {
  Future<ApiResult<StudentProfileModel>> getStudentProfile();
  Future<ApiResult<StudentProfileModel>> updateStudentProfile(
    UpdateStudentProfileRequestModel request,
  );
}
