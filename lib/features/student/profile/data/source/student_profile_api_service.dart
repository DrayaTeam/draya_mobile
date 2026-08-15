import 'package:dio/dio.dart';
import 'package:draya_mobile/core/networking/api_constants.dart';
import 'package:draya_mobile/features/student/profile/data/models/student_profile_model.dart';
import 'package:draya_mobile/features/student/profile/data/models/update_student_profile_request_model.dart';
import 'package:draya_mobile/features/student/profile/data/source/student_profile_api_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'student_profile_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class StudentProfileApiService {
  factory StudentProfileApiService(Dio dio) = _StudentProfileApiService;

  @PUT(StudentProfileApiConstants.updateProfile)
  Future<StudentProfileModel> updateStudentProfile(
    @Body() UpdateStudentProfileRequestModel request,
  );
}
