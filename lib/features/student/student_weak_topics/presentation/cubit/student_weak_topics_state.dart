import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/student/student_weak_topics/domain/entity/ai_revision.dart";
import "package:draya_mobile/features/student/student_weak_topics/domain/entity/practice_exam_generation.dart";
import "package:draya_mobile/features/student/student_weak_topics/domain/entity/student_performance_report.dart";

enum PracticeExamGenerationStatus {
  idle,
  requesting,
  generating,
  completed,
  failed,
}

class StudentWeakTopicsState {
  final CubitStatus status;
  final ApiErrorModel? apiErrorModel;
  final StudentPerformanceReport? report;
  final String? studentId;

  // AI Revision
  final bool isRevisionLoading;
  final ApiErrorModel? revisionError;
  final String? selectedTopicName;
  final AiRevision? aiRevision;

  // Practice Exam Generation
  final PracticeExamGenerationStatus examGenerationStatus;
  final String? examGenerationId;
  final String? generatedExamId;
  final String? examGenerationError;
  final PracticeExamGeneration? practiceExamResponse;

  const StudentWeakTopicsState({
    this.status = CubitStatus.initial,
    this.apiErrorModel,
    this.report,
    this.studentId,
    this.isRevisionLoading = false,
    this.revisionError,
    this.selectedTopicName,
    this.aiRevision,
    this.examGenerationStatus = PracticeExamGenerationStatus.idle,
    this.examGenerationId,
    this.generatedExamId,
    this.examGenerationError,
    this.practiceExamResponse,
  });

  StudentWeakTopicsState copyWith({
    CubitStatus? status,
    ApiErrorModel? apiErrorModel,
    StudentPerformanceReport? report,
    String? studentId,
    bool? isRevisionLoading,
    ApiErrorModel? revisionError,
    String? selectedTopicName,
    AiRevision? aiRevision,
    PracticeExamGenerationStatus? examGenerationStatus,
    String? examGenerationId,
    String? generatedExamId,
    String? examGenerationError,
    PracticeExamGeneration? practiceExamResponse,
  }) {
    return StudentWeakTopicsState(
      status: status ?? this.status,
      apiErrorModel: apiErrorModel ?? this.apiErrorModel,
      report: report ?? this.report,
      studentId: studentId ?? this.studentId,
      isRevisionLoading: isRevisionLoading ?? this.isRevisionLoading,
      revisionError: revisionError,
      selectedTopicName: selectedTopicName ?? this.selectedTopicName,
      aiRevision: aiRevision ?? this.aiRevision,
      examGenerationStatus:
          examGenerationStatus ?? this.examGenerationStatus,
      examGenerationId: examGenerationId ?? this.examGenerationId,
      generatedExamId: generatedExamId ?? this.generatedExamId,
      examGenerationError: examGenerationError,
      practiceExamResponse: practiceExamResponse ?? this.practiceExamResponse,
    );
  }
}
