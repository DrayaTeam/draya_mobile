import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/student/exams_history/domain/entity/student_exam_history.dart";
import "package:draya_mobile/features/student/student_enrolled_classrooms/domain/entity/student_enrolled_classroom.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "exams_history_state.freezed.dart";

@freezed
abstract class ExamsHistoryState with _$ExamsHistoryState {
  const factory ExamsHistoryState({
    @Default(CubitStatus.initial) CubitStatus status,
    @Default([]) List<StudentExamWithAttempts> exams,
    @Default([]) List<StudentEnrolledClassroom> classrooms,
    @Default(0) int totalCount,
    @Default(1) int currentPage,
    @Default(false) bool hasReachedMax,
    @Default(false) bool isLoadingMore,
    String? selectedClassroomId,
    ApiErrorModel? apiErrorModel,
  }) = _ExamsHistoryState;
}
