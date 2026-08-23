import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/students_grades/domain/usecases/get_attempt_review_use_case.dart";
import "package:draya_mobile/features/teacher/students_grades/domain/usecases/override_answer_score_params.dart";
import "package:draya_mobile/features/teacher/students_grades/domain/usecases/override_answer_score_use_case.dart";
import "package:draya_mobile/features/teacher/students_grades/presentation/cubit/attempt_review_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class AttemptReviewCubit extends Cubit<AttemptReviewState> {
  final GetAttemptReviewUseCase _getAttemptReviewUseCase;
  final OverrideAnswerScoreUseCase _overrideAnswerScoreUseCase;

  AttemptReviewCubit(
    this._getAttemptReviewUseCase,
    this._overrideAnswerScoreUseCase,
  ) : super(const AttemptReviewState());

  Future<void> loadResults(String attemptId) async {
    emit(
      state.copyWith(
        status: CubitStatus.loading,
        apiErrorModel: null,
      ),
    );

    final result = await _getAttemptReviewUseCase(attemptId: attemptId);

    result.when(
      success: (results) => emit(
        state.copyWith(
          status: CubitStatus.success,
          results: results,
        ),
      ),
      failure: (error) => emit(
        state.copyWith(
          status: CubitStatus.error,
          apiErrorModel: error,
        ),
      ),
    );
  }

  void setOverrideScore(String answerId, double score) {
    final updated = Map<String, double>.from(state.pendingOverrides);
    updated[answerId] = score;
    emit(state.copyWith(pendingOverrides: updated));
  }

  Future<bool> submitOverride(String attemptId, String answerId) async {
    final score = state.pendingOverrides[answerId];
    if (score == null || state.isSubmittingOverride) return false;

    emit(state.copyWith(isSubmittingOverride: true, apiErrorModel: null));

    final result = await _overrideAnswerScoreUseCase(
      OverrideAnswerScoreParams(
        attemptId: attemptId,
        answerId: answerId,
        newScore: score,
      ),
    );

    bool succeeded = false;

    result.when(
      success: (_) {
        succeeded = true;
        final updated = Map<String, double>.from(state.pendingOverrides);
        updated.remove(answerId);
        emit(state.copyWith(isSubmittingOverride: false));
      },
      failure: (error) => emit(
        state.copyWith(isSubmittingOverride: false, apiErrorModel: error),
      ),
    );

    if (succeeded && state.status == CubitStatus.success) {
      await loadResults(attemptId);
    }

    return succeeded;
  }
}
