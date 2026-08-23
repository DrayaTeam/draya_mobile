import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/teacher/reports/data/models/performance_report_model.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "reports_state.freezed.dart";

@freezed
abstract class ReportsState with _$ReportsState {
  const factory ReportsState({
    @Default({}) Map<String, PerformanceReportModel> reportsByStudentId,
    @Default({}) Set<String> loadingStudentIds,
    @Default({}) Map<String, ApiErrorModel> errorsByStudentId,
    ApiErrorModel? apiErrorModel,
  }) = _ReportsState;
}
