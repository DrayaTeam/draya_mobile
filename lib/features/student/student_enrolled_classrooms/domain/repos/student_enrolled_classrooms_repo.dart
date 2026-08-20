import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/student_enrolled_classrooms/data/models/student_enrolled_classroom_paged_result_model.dart";

abstract class StudentEnrolledClassroomsRepo {
  Future<ApiResult<StudentEnrolledClassroomPagedResultModel>> getStudentEnrolledClassrooms({
    int page = 1,
    int pageSize = 20,
    String? subjectId,
    String? gradeLevelId,
    String? classroomTypeId,
  });

  Future<ApiResult<void>> enrollClassroom(String enrollmentCode);
}
