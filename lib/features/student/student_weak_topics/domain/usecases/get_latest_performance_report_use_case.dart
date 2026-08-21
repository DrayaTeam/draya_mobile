import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/student_weak_topics/domain/entity/student_performance_report.dart";
import "package:draya_mobile/features/student/student_weak_topics/domain/repos/student_weak_topics_repo.dart";

class GetLatestPerformanceReportUseCase
    implements AppUseCase<ApiResult<StudentPerformanceReport>, String> {
  final StudentWeakTopicsRepo _repository;

  GetLatestPerformanceReportUseCase(this._repository);

  @override
  Future<ApiResult<StudentPerformanceReport>> call({String? params}) async {
    return await _repository.getLatestPerformanceReport(params ?? "");
  }
}
