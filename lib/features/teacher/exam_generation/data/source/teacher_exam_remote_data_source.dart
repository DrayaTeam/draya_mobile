import "package:dio/dio.dart";
import "package:draya_mobile/core/networking/api_constants.dart";
import "package:draya_mobile/features/teacher/exam_generation/data/models/teacher_exam_models.dart";

class TeacherExamRemoteDataSource {
  final Dio _dio;

  TeacherExamRemoteDataSource(this._dio);

  Future<ExamGenerationResponseModel> generateExam(
    ExamGenerationRequestModel request,
  ) async {
    final response = await _dio.post(
      "${ApiConstants.baseUrl}exams/generate",
      data: request.toJson(),
    );
    return ExamGenerationResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<AiQuotaModel> getQuota() async {
    final response = await _dio.get(
      "${ApiConstants.baseUrl}exams/quota",
    );
    return AiQuotaModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<ExamGenerationStatusModel> getGenerationStatus(
    String generationId,
  ) async {
    final response = await _dio.get(
      "${ApiConstants.baseUrl}exams/generations/$generationId",
    );
    return ExamGenerationStatusModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<TeacherExamDetailModel> getExamDetails(String examId) async {
    final response = await _dio.get(
      "${ApiConstants.baseUrl}exams/$examId",
    );
    return TeacherExamDetailModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  Future<String> addQuestion({
    required String examId,
    required TeacherExamQuestionModel question,
  }) async {
    final response = await _dio.post(
      "${ApiConstants.baseUrl}exams/$examId/questions",
      data: question.toJson(),
    );
    final data = response.data as Map<String, dynamic>;
    return (data["questionId"] ?? data["id"] ?? "") as String;
  }

  Future<void> updateQuestion({
    required String examId,
    required String questionId,
    required TeacherExamQuestionModel question,
  }) async {
    await _dio.put(
      "${ApiConstants.baseUrl}exams/$examId/questions/$questionId",
      data: question.toJson(),
    );
  }

  Future<void> deleteQuestion({
    required String examId,
    required String questionId,
  }) async {
    await _dio.delete(
      "${ApiConstants.baseUrl}exams/$examId/questions/$questionId",
    );
  }

  Future<RefinedQuestionResponseModel> refineQuestion({
    required String examId,
    required String questionId,
    required String instruction,
  }) async {
    final response = await _dio.post(
      "${ApiConstants.baseUrl}exams/$examId/questions/$questionId/refine",
      data: {"instruction": instruction},
    );
    return RefinedQuestionResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
