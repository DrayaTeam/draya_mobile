import "package:dio/dio.dart";
import "package:draya_mobile/core/networking/api_constants.dart";
import "package:draya_mobile/features/student/exams_history/data/models/student_exams_history_models.dart";
import "package:draya_mobile/features/student/exams_history/data/source/exams_history_api_constants.dart";
import "package:retrofit/retrofit.dart";

part "exams_history_api_service.g.dart";

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ExamsHistoryApiService {
  factory ExamsHistoryApiService(Dio dio) = _ExamsHistoryApiService;

  @GET(ExamsHistoryApiConstants.studentExams)
  Future<StudentExamsHistoryPagedResultModel> getStudentExams({
    @Query(ExamsHistoryApiConstants.page) int? page,
    @Query(ExamsHistoryApiConstants.pageSize) int? pageSize,
  });
}
