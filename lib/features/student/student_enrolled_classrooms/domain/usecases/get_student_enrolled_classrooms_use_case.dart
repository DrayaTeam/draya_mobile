import 'package:draya_mobile/core/helpers/app_use_case.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/student/student_enrolled_classrooms/data/models/student_enrolled_classroom_paged_result_model.dart';
import 'package:draya_mobile/features/student/student_enrolled_classrooms/domain/repos/student_enrolled_classrooms_repo.dart';

class StudentEnrolledClassroomsParams {
  final int page;
  final int pageSize;
  final String? subjectId;
  final String? gradeLevelId;
  final String? classroomTypeId;

  const StudentEnrolledClassroomsParams({
    this.page = 1,
    this.pageSize = 20,
    this.subjectId,
    this.gradeLevelId,
    this.classroomTypeId,
  });
}

class GetStudentEnrolledClassroomsUseCase
    implements
        AppUseCase<
          ApiResult<StudentEnrolledClassroomPagedResultModel>,
          StudentEnrolledClassroomsParams
        > {
  final StudentEnrolledClassroomsRepo _repo;

  GetStudentEnrolledClassroomsUseCase(this._repo);

  @override
  Future<ApiResult<StudentEnrolledClassroomPagedResultModel>> call({
    StudentEnrolledClassroomsParams? params,
  }) async {
    final request = params ??
        const StudentEnrolledClassroomsParams(
          page: 1,
          pageSize: 20,
        );

    return _repo.getStudentEnrolledClassrooms(
      page: request.page,
      pageSize: request.pageSize,
      subjectId: request.subjectId,
      gradeLevelId: request.gradeLevelId,
      classroomTypeId: request.classroomTypeId,
    );
  }
}
