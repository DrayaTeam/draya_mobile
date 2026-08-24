import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/reports/data/models/performance_report_model.dart";

abstract interface class ReportsRepo {
  Future<ApiResult<PerformanceReportModel>> getPerformanceReport({
    required String studentId,
  });

  Future<ApiResult<void>> approveReport({required String reportId});
}
