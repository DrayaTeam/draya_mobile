import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/teacher/students_grades/data/models/exam_attempt_model.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "exam_attempts_state.freezed.dart";

@freezed
abstract class ExamAttemptsState with _$ExamAttemptsState {
  const factory ExamAttemptsState({
    @Default(CubitStatus.initial) CubitStatus status,
    @Default([]) List<ExamAttemptModel> attempts,
    @Default(0) int totalCount,
    @Default(1) int currentPage,
    @Default(false) bool hasReachedMax,
    @Default(false) bool isLoadingMore,
    ApiErrorModel? apiErrorModel,
  }) = _ExamAttemptsState;
}
