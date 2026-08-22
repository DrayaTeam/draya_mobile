import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/student/student_enrolled_classrooms/domain/entity/student_enrolled_classroom.dart";

class StudentFeedbackState {
  final CubitStatus status;
  final List<StudentEnrolledClassroom> classrooms;
  final List<String> submittedClassroomIds;
  final String? submittingClassroomId;
  final ApiErrorModel? apiErrorModel;

  const StudentFeedbackState({
    this.status = CubitStatus.initial,
    this.classrooms = const [],
    this.submittedClassroomIds = const [],
    this.submittingClassroomId,
    this.apiErrorModel,
  });

  bool isSubmitting(String classroomId) =>
      submittingClassroomId == classroomId;

  bool hasSubmitted(String classroomId) =>
      submittedClassroomIds.contains(classroomId);

  StudentFeedbackState copyWith({
    CubitStatus? status,
    List<StudentEnrolledClassroom>? classrooms,
    List<String>? submittedClassroomIds,
    String? submittingClassroomId,
    bool clearSubmittingClassroomId = false,
    ApiErrorModel? apiErrorModel,
  }) {
    return StudentFeedbackState(
      status: status ?? this.status,
      classrooms: classrooms ?? this.classrooms,
      submittedClassroomIds:
          submittedClassroomIds ?? this.submittedClassroomIds,
      submittingClassroomId: clearSubmittingClassroomId
          ? null
          : (submittingClassroomId ?? this.submittingClassroomId),
      apiErrorModel: apiErrorModel ?? this.apiErrorModel,
    );
  }
}
