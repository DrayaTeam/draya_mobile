import "package:dio/dio.dart";
import "package:draya_mobile/core/networking/api_constants.dart";
import "package:draya_mobile/features/student/exams/data/models/attempt_models.dart";
import "package:draya_mobile/features/student/exams/data/models/grading_models.dart";
import "package:draya_mobile/features/student/exams/data/models/student_exam_models.dart";
import "package:draya_mobile/features/student/exams/data/source/student_exam_api_constants.dart";
import "package:retrofit/retrofit.dart";

part "student_exam_api_service.g.dart";

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class StudentExamApiService {
  factory StudentExamApiService(Dio dio) = _StudentExamApiService;

  @GET(StudentExamApiConstants.studentExams)
  Future<StudentExamsPageModel> getStudentExams({
    @Query("page") required int page,
    @Query("pageSize") required int pageSize,
  });

  @GET(StudentExamApiConstants.examDetails)
  Future<StudentExamModel> getExamDetails(
    @Path(StudentExamApiConstants.examId) String examId,
  );

  @POST(StudentExamApiConstants.startAttempt)
  Future<StartAttemptResponseModel> startAttempt(
    @Body() StartAttemptRequestModel request,
  );

  @POST(StudentExamApiConstants.submitAttempt)
  Future<SubmitAttemptResponseModel> submitAttempt(
    @Path(StudentExamApiConstants.attemptId) String attemptId,
    @Body() SubmitAttemptRequestModel request,
  );

  @GET(StudentExamApiConstants.gradingJobStatus)
  Future<GradingJobModel> getGradingJobStatus(
    @Path(StudentExamApiConstants.jobId) String jobId,
  );

  @GET(StudentExamApiConstants.attemptResults)
  Future<ExamResultModel> getAttemptResults(
    @Path(StudentExamApiConstants.attemptId) String attemptId,
  );
}
