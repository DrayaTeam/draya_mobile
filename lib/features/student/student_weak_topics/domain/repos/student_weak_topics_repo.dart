import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/student_weak_topics/domain/entity/ai_revision.dart";
import "package:draya_mobile/features/student/student_weak_topics/domain/entity/practice_exam_generation.dart";
import "package:draya_mobile/features/student/student_weak_topics/domain/entity/student_performance_report.dart";

abstract class StudentWeakTopicsRepo {
  Future<ApiResult<StudentPerformanceReport>> getLatestPerformanceReport(
    String studentId,
  );

  Future<ApiResult<AiRevision>> getAiRevision({
    required String studentId,
    required String topicName,
  });

  Future<ApiResult<PracticeExamGeneration>> generatePracticeExam({
    required String studentId,
    required String topicName,
  });

  Future<ApiResult<PracticeExamGenerationStatus>> getGenerationStatus(
    String generationId,
  );
}
