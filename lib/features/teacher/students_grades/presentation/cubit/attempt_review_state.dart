import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/teacher/students_grades/data/models/attempt_review_models.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "attempt_review_state.freezed.dart";

@freezed
abstract class AttemptReviewState with _$AttemptReviewState {
  const factory AttemptReviewState({
    @Default(CubitStatus.initial) CubitStatus status,
    AttemptReviewResultsModel? results,
    @Default({}) Map<String, double> pendingOverrides,
    @Default(false) bool isSubmittingOverride,
    ApiErrorModel? apiErrorModel,
  }) = _AttemptReviewState;
}
