import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/student/student_enrolled_classrooms/domain/entity/student_enrolled_classroom.dart";

class StudentEnrolledClassroomsState {
  final CubitStatus status;
  final List<StudentEnrolledClassroom> classrooms;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final ApiErrorModel? apiErrorModel;

  const StudentEnrolledClassroomsState({
    this.status = CubitStatus.initial,
    this.classrooms = const [],
    this.page = 1,
    this.pageSize = 20,
    this.totalCount = 0,
    this.totalPages = 0,
    this.apiErrorModel,
  });

  StudentEnrolledClassroomsState copyWith({
    CubitStatus? status,
    List<StudentEnrolledClassroom>? classrooms,
    int? page,
    int? pageSize,
    int? totalCount,
    int? totalPages,
    ApiErrorModel? apiErrorModel,
  }) {
    return StudentEnrolledClassroomsState(
      status: status ?? this.status,
      classrooms: classrooms ?? this.classrooms,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
      totalPages: totalPages ?? this.totalPages,
      apiErrorModel: apiErrorModel ?? this.apiErrorModel,
    );
  }
}
