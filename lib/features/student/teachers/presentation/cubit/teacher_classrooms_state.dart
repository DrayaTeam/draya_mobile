import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/student/teachers/data/models/teacher_classroom_model.dart";

class TeacherClassroomsState {
  final CubitStatus status;
  final List<TeacherClassroomModel> classrooms;
  final String? teacherId;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final ApiErrorModel? apiErrorModel;

  const TeacherClassroomsState({
    this.status = CubitStatus.initial,
    this.classrooms = const [],
    this.teacherId,
    this.page = 1,
    this.pageSize = 20,
    this.totalCount = 0,
    this.totalPages = 0,
    this.apiErrorModel,
  });

  TeacherClassroomsState copyWith({
    CubitStatus? status,
    List<TeacherClassroomModel>? classrooms,
    String? teacherId,
    int? page,
    int? pageSize,
    int? totalCount,
    int? totalPages,
    ApiErrorModel? apiErrorModel,
  }) {
    return TeacherClassroomsState(
      status: status ?? this.status,
      classrooms: classrooms ?? this.classrooms,
      teacherId: teacherId ?? this.teacherId,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
      totalPages: totalPages ?? this.totalPages,
      apiErrorModel: apiErrorModel ?? this.apiErrorModel,
    );
  }
}
