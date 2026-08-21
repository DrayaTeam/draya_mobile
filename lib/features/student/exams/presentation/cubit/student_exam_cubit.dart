import "dart:async";
import "dart:math";

import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/exams/domain/entity/student_exam.dart";
import "package:draya_mobile/features/student/exams/domain/usecases/get_attempt_results_use_case.dart";
import "package:draya_mobile/features/student/exams/domain/usecases/get_exam_details_use_case.dart";
import "package:draya_mobile/features/student/exams/domain/usecases/get_grading_job_status_use_case.dart";
import "package:draya_mobile/features/student/exams/domain/usecases/start_exam_attempt_use_case.dart";
import "package:draya_mobile/features/student/exams/domain/usecases/submit_exam_attempt_use_case.dart";
import "package:draya_mobile/features/student/exams/presentation/cubit/student_exam_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class StudentExamCubit extends Cubit<StudentExamState> {
  final GetExamDetailsUseCase _getExamDetailsUseCase;
  final StartExamAttemptUseCase _startExamAttemptUseCase;
  final SubmitExamAttemptUseCase _submitExamAttemptUseCase;
  final GetGradingJobStatusUseCase _getGradingJobStatusUseCase;
  final GetAttemptResultsUseCase _getAttemptResultsUseCase;

  Timer? _gradingPollTimer;
  int _pollCount = 0;

  StudentExamCubit(
    this._getExamDetailsUseCase,
    this._startExamAttemptUseCase,
    this._submitExamAttemptUseCase,
    this._getGradingJobStatusUseCase,
    this._getAttemptResultsUseCase,
  ) : super(const StudentExamState());

  @override
  Future<void> close() {
    _gradingPollTimer?.cancel();
    return super.close();
  }

  Future<void> loadExamDetails(String examId) async {
    emit(
      state.copyWith(
        examDetailStatus: CubitStatus.loading,
        clearError: true,
      ),
    );

    final result = await _getExamDetailsUseCase.call(params: examId);
    switch (result) {
      case Success(data: final exam):
        // Initialize answer entries for each question
        final initialAnswers = <String, GradedAnswer>{};
        for (final q in exam.questions) {
          initialAnswers[q.id] = GradedAnswer(
            examQuestionId: q.id,
            answerText: "",
            selectedOptionId: null,
          );
        }
        emit(
          state.copyWith(
            examDetailStatus: CubitStatus.success,
            currentExam: exam,
            answers: initialAnswers,
          ),
        );
      case Failure(apiErrorModel: final error):
        emit(
          state.copyWith(
            examDetailStatus: CubitStatus.error,
            apiErrorModel: error,
          ),
        );
    }
  }

  Future<bool> startAttempt(String examId) async {
    emit(
      state.copyWith(
        attemptStatus: CubitStatus.loading,
        clearError: true,
      ),
    );

    final result = await _startExamAttemptUseCase.call(params: examId);
    switch (result) {
      case Success(data: final attemptId):
        emit(
          state.copyWith(
            attemptStatus: CubitStatus.success,
            attemptId: attemptId,
          ),
        );
        return true;
      case Failure(apiErrorModel: final error):
        emit(
          state.copyWith(
            attemptStatus: CubitStatus.error,
            apiErrorModel: error,
          ),
        );
        return false;
    }
    return false;
  }

  void selectOption(String questionId, String optionId) {
    final updatedAnswers = Map<String, GradedAnswer>.from(state.answers);
    final currentAnswer = updatedAnswers[questionId];

    updatedAnswers[questionId] = GradedAnswer(
      answerId: currentAnswer?.answerId,
      examQuestionId: questionId,
      answerText: "",
      selectedOptionId: optionId,
    );

    emit(state.copyWith(answers: updatedAnswers));
  }

  void setAnswerText(String questionId, String text) {
    final updatedAnswers = Map<String, GradedAnswer>.from(state.answers);
    final currentAnswer = updatedAnswers[questionId];

    updatedAnswers[questionId] = GradedAnswer(
      answerId: currentAnswer?.answerId,
      examQuestionId: questionId,
      answerText: text,
      selectedOptionId: null,
    );

    emit(state.copyWith(answers: updatedAnswers));
  }

  Future<void> submitExam() async {
    final attemptId = state.attemptId;
    if (attemptId == null || attemptId.isEmpty) return;

    emit(
      state.copyWith(
        submissionStatus: CubitStatus.loading,
        clearError: true,
      ),
    );

    final idempotencyKey = _generateIdempotencyKey();
    final answersList = state.answers.values.toList();

    final result = await _submitExamAttemptUseCase.call(
      params: SubmitExamAttemptParams(
        attemptId: attemptId,
        idempotencyKey: idempotencyKey,
        answers: answersList,
      ),
    );

    switch (result) {
      case Success(data: final response):
        final jobId = response.gradingJobId;
        final targetAttemptId = response.attemptId ?? attemptId;

        if (jobId != null && jobId.trim().isNotEmpty) {
          emit(
            state.copyWith(
              submissionStatus: CubitStatus.success,
              gradingJobId: jobId,
              gradingStatus: CubitStatus.loading,
            ),
          );
          _startGradingPolling(jobId, targetAttemptId);
        } else {
          emit(
            state.copyWith(
              submissionStatus: CubitStatus.success,
              gradingStatus: CubitStatus.success,
            ),
          );
          await loadResults(targetAttemptId);
        }
      case Failure(apiErrorModel: final error):
        emit(
          state.copyWith(
            submissionStatus: CubitStatus.error,
            apiErrorModel: error,
          ),
        );
    }
  }

  void _startGradingPolling(String jobId, String attemptId) {
    _gradingPollTimer?.cancel();
    _pollCount = 0;

    _gradingPollTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      _pollCount++;
      if (_pollCount > 40) {
        // Timeout after 2 minutes
        timer.cancel();
        emit(
          state.copyWith(
            gradingStatus: CubitStatus.error,
          ),
        );
        return;
      }

      final result = await _getGradingJobStatusUseCase.call(params: jobId);
      switch (result) {
        case Success(data: final jobStatus):
          emit(
            state.copyWith(
              gradingJobStatus: jobStatus,
            ),
          );

          if (jobStatus.status == GradingJobState.completed ||
              jobStatus.status == GradingJobState.completedWithWarning) {
            timer.cancel();
            emit(
              state.copyWith(
                gradingStatus: CubitStatus.success,
              ),
            );
            await loadResults(attemptId);
          } else if (jobStatus.status == GradingJobState.failed) {
            timer.cancel();
            emit(
              state.copyWith(
                gradingStatus: CubitStatus.error,
              ),
            );
          }
        case Failure():
          // Keep polling until timeout or success
          break;
      }
    });
  }

  Future<void> loadResults(String attemptId) async {
    emit(
      state.copyWith(
        resultsStatus: CubitStatus.loading,
        clearError: true,
      ),
    );

    final result = await _getAttemptResultsUseCase.call(params: attemptId);
    switch (result) {
      case Success(data: final results):
        emit(
          state.copyWith(
            resultsStatus: CubitStatus.success,
            attemptResult: results,
          ),
        );
      case Failure(apiErrorModel: final error):
        emit(
          state.copyWith(
            resultsStatus: CubitStatus.error,
            apiErrorModel: error,
          ),
        );
    }
  }

  // Anti-cheating features
  void recordTabAway() {
    final newCount = state.tabAwayCount + 1;
    emit(
      state.copyWith(
        tabAwayCount: newCount,
        isAntiCheatWarningVisible: true,
      ),
    );
  }

  void dismissAntiCheatWarning() {
    emit(state.copyWith(isAntiCheatWarningVisible: false));
  }

  String _generateIdempotencyKey() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomValue = random.nextInt(1000000);
    return "submission-$timestamp-$randomValue";
  }
}
