import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/teacher/classrooms/domain/entity/classroom.dart";

class TeacherFeedbackState {
  final CubitStatus status;
  final List<Classroom> classrooms;
  final ApiErrorModel? apiErrorModel;

  const TeacherFeedbackState({
    this.status = CubitStatus.initial,
    this.classrooms = const [],
    this.apiErrorModel,
  });

  TeacherFeedbackState copyWith({
    CubitStatus? status,
    List<Classroom>? classrooms,
    ApiErrorModel? apiErrorModel,
  }) {
    return TeacherFeedbackState(
      status: status ?? this.status,
      classrooms: classrooms ?? this.classrooms,
      apiErrorModel: apiErrorModel ?? this.apiErrorModel,
    );
  }
}
