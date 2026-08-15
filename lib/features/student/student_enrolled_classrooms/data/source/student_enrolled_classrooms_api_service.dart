import 'package:dio/dio.dart';
import 'package:draya_mobile/core/networking/api_constants.dart';
import 'package:draya_mobile/features/student/student_enrolled_classrooms/data/models/enroll_classroom_request_model.dart';
import 'package:draya_mobile/features/student/student_enrolled_classrooms/data/models/student_enrolled_classroom_paged_result_model.dart';
import 'package:retrofit/retrofit.dart';

part 'student_enrolled_classrooms_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class StudentEnrolledClassroomsApiService {
  factory StudentEnrolledClassroomsApiService(Dio dio) =
      _StudentEnrolledClassroomsApiService;

  @GET('/classrooms')
  Future<StudentEnrolledClassroomPagedResultModel>
      getStudentEnrolledClassrooms({
    @Query('page') int page = 1,
    @Query('pageSize') int pageSize = 20,
    @Query('subjectId') String? subjectId,
    @Query('gradeLevelId') String? gradeLevelId,
    @Query('classroomTypeId') String? classroomTypeId,
  });

  @POST('/classrooms/enroll')
  Future<void> enrollClassroom(@Body() EnrollClassroomRequestModel request);
}
