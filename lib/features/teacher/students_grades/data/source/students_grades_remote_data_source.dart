import "package:dio/dio.dart";
import "package:draya_mobile/core/networking/api_constants.dart";
import "package:draya_mobile/features/teacher/students_grades/data/models/exam_attempts_paged_result_model.dart";
import "package:draya_mobile/features/teacher/students_grades/data/source/students_grades_api_constants.dart";
import "package:retrofit/retrofit.dart";

part "students_grades_remote_data_source.g.dart";

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class StudentsGradesRemoteDataSource {
  factory StudentsGradesRemoteDataSource(Dio dio) =
      _StudentsGradesRemoteDataSource;

  @GET(StudentsGradesApiConstants.examAttempts)
  Future<ExamAttemptsPagedResultModel> getExamAttempts(
    @Path(StudentsGradesApiConstants.examId) String examId, {
    @Query("page") int? page,
    @Query("pageSize") int? pageSize,
  });
}
