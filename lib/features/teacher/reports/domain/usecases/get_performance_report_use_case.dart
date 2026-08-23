import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/reports/data/models/performance_report_model.dart";
import "package:draya_mobile/features/teacher/reports/domain/repos/reports_repo.dart";

class GetPerformanceReportUseCase
    implements AppUseCase<ApiResult<PerformanceReportModel>, String> {
  final ReportsRepo _reportsRepo;

  GetPerformanceReportUseCase(this._reportsRepo);

  @override
  Future<ApiResult<PerformanceReportModel>> call({String? params}) async {
    return await _reportsRepo.getPerformanceReport(studentId: params!);
  }
}
