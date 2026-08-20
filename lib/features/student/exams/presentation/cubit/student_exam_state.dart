import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/student/exams/domain/entity/student_exam.dart";

class StudentExamState {
  final CubitStatus examDetailStatus;
  final StudentExam? currentExam;
  final CubitStatus attemptStatus;
  final String? attemptId;
  final Map<String, GradedAnswer> answers;
  final CubitStatus submissionStatus;
  final String? gradingJobId;
  final CubitStatus gradingStatus;
  final GradingJobStatus? gradingJobStatus;
  final CubitStatus resultsStatus;
  final ExamAttemptResult? attemptResult;
  final ApiErrorModel? apiErrorModel;
  final int tabAwayCount;
  final bool isAntiCheatWarningVisible;

  const StudentExamState({
    this.examDetailStatus = CubitStatus.initial,
    this.currentExam,
    this.attemptStatus = CubitStatus.initial,
    this.attemptId,
    this.answers = const {},
    this.submissionStatus = CubitStatus.initial,
    this.gradingJobId,
    this.gradingStatus = CubitStatus.initial,
    this.gradingJobStatus,
    this.resultsStatus = CubitStatus.initial,
    this.attemptResult,
    this.apiErrorModel,
    this.tabAwayCount = 0,
    this.isAntiCheatWarningVisible = false,
  });

  int get answeredQuestionsCount =>
      answers.values.where((a) {
        final hasOption = a.selectedOptionId != null && a.selectedOptionId!.isNotEmpty;
        final hasText = a.answerText != null && a.answerText!.trim().isNotEmpty;
        return hasOption || hasText;
      }).length;

  int get totalQuestionsCount => currentExam?.questions.length ?? 0;

  bool isQuestionAnswered(String questionId) {
    final answer = answers[questionId];
    if (answer == null) return false;
    final hasOption =
        answer.selectedOptionId != null && answer.selectedOptionId!.isNotEmpty;
    final hasText =
        answer.answerText != null && answer.answerText!.trim().isNotEmpty;
    return hasOption || hasText;
  }

  StudentExamState copyWith({
    CubitStatus? examDetailStatus,
    StudentExam? currentExam,
    CubitStatus? attemptStatus,
    String? attemptId,
    Map<String, GradedAnswer>? answers,
    CubitStatus? submissionStatus,
    String? gradingJobId,
    CubitStatus? gradingStatus,
    GradingJobStatus? gradingJobStatus,
    CubitStatus? resultsStatus,
    ExamAttemptResult? attemptResult,
    ApiErrorModel? apiErrorModel,
    int? tabAwayCount,
    bool? isAntiCheatWarningVisible,
    bool clearError = false,
  }) {
    return StudentExamState(
      examDetailStatus: examDetailStatus ?? this.examDetailStatus,
      currentExam: currentExam ?? this.currentExam,
      attemptStatus: attemptStatus ?? this.attemptStatus,
      attemptId: attemptId ?? this.attemptId,
      answers: answers ?? this.answers,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      gradingJobId: gradingJobId ?? this.gradingJobId,
      gradingStatus: gradingStatus ?? this.gradingStatus,
      gradingJobStatus: gradingJobStatus ?? this.gradingJobStatus,
      resultsStatus: resultsStatus ?? this.resultsStatus,
      attemptResult: attemptResult ?? this.attemptResult,
      apiErrorModel: clearError ? null : (apiErrorModel ?? this.apiErrorModel),
      tabAwayCount: tabAwayCount ?? this.tabAwayCount,
      isAntiCheatWarningVisible:
          isAntiCheatWarningVisible ?? this.isAntiCheatWarningVisible,
    );
  }
}
