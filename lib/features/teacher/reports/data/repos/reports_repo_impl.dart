import "package:draya_mobile/core/networking/api_error_handler.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/reports/data/models/performance_report_model.dart";
import "package:draya_mobile/features/teacher/reports/data/sources/reports_api_service.dart";
import "package:draya_mobile/features/teacher/reports/domain/repos/reports_repo.dart";

class ReportsRepoImpl implements ReportsRepo {
  final ReportsApiService _reportsApiService;

  ReportsRepoImpl(this._reportsApiService);

  @override
  Future<ApiResult<PerformanceReportModel>> getPerformanceReport({
    required String studentId,
  }) async {
    try {
      final response = await _reportsApiService.getPerformanceReport(studentId);

      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
