import "package:dio/dio.dart";
import "package:draya_mobile/core/networking/api_constants.dart";
import "package:draya_mobile/features/teacher/reports/data/models/performance_report_model.dart";
import "package:draya_mobile/features/teacher/reports/data/sources/reports_api_constants.dart";
import "package:retrofit/retrofit.dart";

part "reports_api_service.g.dart";

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ReportsApiService {
  factory ReportsApiService(Dio dio) = _ReportsApiService;

  @GET(ReportsApiConstants.performanceReports)
  Future<PerformanceReportModel> getPerformanceReport(
    @Path(ReportsApiConstants.studentId) String studentId,
  );

  @POST(ReportsApiConstants.approveReport)
  Future<void> approveReport(
    @Path(ReportsApiConstants.reportId) String reportId,
  );
}
