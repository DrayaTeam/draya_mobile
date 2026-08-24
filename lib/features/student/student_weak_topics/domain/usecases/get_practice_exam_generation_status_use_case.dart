import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/student_weak_topics/domain/entity/practice_exam_generation.dart";
import "package:draya_mobile/features/student/student_weak_topics/domain/repos/student_weak_topics_repo.dart";

class GetPracticeExamGenerationStatusUseCase
    implements
        AppUseCase<ApiResult<PracticeExamGenerationStatus>, String> {
  final StudentWeakTopicsRepo _repository;

  GetPracticeExamGenerationStatusUseCase(this._repository);

  @override
  Future<ApiResult<PracticeExamGenerationStatus>> call({
    String? params,
  }) async {
    return await _repository.getGenerationStatus(params ?? "");
  }
}
