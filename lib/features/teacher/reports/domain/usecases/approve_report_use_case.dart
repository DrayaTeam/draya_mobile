import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/reports/domain/repos/reports_repo.dart";

class ApproveReportUseCase implements AppUseCase<ApiResult<void>, String> {
  final ReportsRepo _reportsRepo;

  ApproveReportUseCase(this._reportsRepo);
  @override
  Future<ApiResult<void>> call({String? params}) async {
    return await _reportsRepo.approveReport(reportId: params!);
  }
}
