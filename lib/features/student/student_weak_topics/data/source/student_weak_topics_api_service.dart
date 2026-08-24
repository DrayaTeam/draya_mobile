import "package:dio/dio.dart";
import "package:draya_mobile/core/networking/api_constants.dart";
import "package:draya_mobile/features/student/student_weak_topics/data/models/ai_revision_model.dart";
import "package:draya_mobile/features/student/student_weak_topics/data/models/practice_exam_generation_model.dart";
import "package:draya_mobile/features/student/student_weak_topics/data/models/student_performance_report_model.dart";
import "package:retrofit/retrofit.dart";

part "student_weak_topics_api_service.g.dart";

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class StudentWeakTopicsApiService {
  factory StudentWeakTopicsApiService(Dio dio, {String baseUrl}) =
      _StudentWeakTopicsApiService;

  @GET("students/{studentId}/performance-reports/latest")
  Future<StudentPerformanceReportModel> getLatestPerformanceReport(
    @Path("studentId") String studentId,
  );

  @GET("students/{studentId}/weak-topics/{topicName}/revision")
  Future<AiRevisionModel> getAiRevision(
    @Path("studentId") String studentId,
    @Path("topicName") String topicName,
  );

  @POST("students/{studentId}/weak-topics/{topicName}/practice-exam")
  Future<PracticeExamGenerationResponseModel> generatePracticeExam(
    @Path("studentId") String studentId,
    @Path("topicName") String topicName,
    @Body() Map<String, dynamic> body,
  );

  @GET("exams/generations/{generationId}")
  Future<PracticeExamGenerationStatusModel> getGenerationStatus(
    @Path("generationId") String generationId,
  );
}
