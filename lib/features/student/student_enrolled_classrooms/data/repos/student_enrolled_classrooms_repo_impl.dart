import 'package:draya_mobile/core/networking/api_error_handler.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/student/student_enrolled_classrooms/data/models/enroll_classroom_request_model.dart';
import 'package:draya_mobile/features/student/student_enrolled_classrooms/data/models/student_enrolled_classroom_paged_result_model.dart';
import 'package:draya_mobile/features/student/student_enrolled_classrooms/data/source/student_enrolled_classrooms_api_service.dart';
import 'package:draya_mobile/features/student/student_enrolled_classrooms/domain/repos/student_enrolled_classrooms_repo.dart';

class StudentEnrolledClassroomsRepoImpl
    implements StudentEnrolledClassroomsRepo {
  final StudentEnrolledClassroomsApiService _apiService;

  StudentEnrolledClassroomsRepoImpl(this._apiService);

  @override
  Future<ApiResult<StudentEnrolledClassroomPagedResultModel>>
      getStudentEnrolledClassrooms({
    int page = 1,
    int pageSize = 20,
    String? subjectId,
    String? gradeLevelId,
    String? classroomTypeId,
  }) async {
    try {
      final response = await _apiService.getStudentEnrolledClassrooms(
        page: page,
        pageSize: pageSize,
        subjectId: subjectId,
        gradeLevelId: gradeLevelId,
        classroomTypeId: classroomTypeId,
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<void>> enrollClassroom(String enrollmentCode) async {
    try {
      await _apiService.enrollClassroom(
        EnrollClassroomRequestModel(enrollmentCode: enrollmentCode.trim()),
      );
      return const ApiResult<void>.success(null);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
