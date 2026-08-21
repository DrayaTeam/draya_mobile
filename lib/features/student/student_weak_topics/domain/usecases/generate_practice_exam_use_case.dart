import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/student_weak_topics/domain/entity/practice_exam_generation.dart";
import "package:draya_mobile/features/student/student_weak_topics/domain/repos/student_weak_topics_repo.dart";

class GeneratePracticeExamParams {
  final String studentId;
  final String topicName;

  const GeneratePracticeExamParams({
    required this.studentId,
    required this.topicName,
  });
}

class GeneratePracticeExamUseCase
    implements AppUseCase<ApiResult<PracticeExamGeneration>, GeneratePracticeExamParams> {
  final StudentWeakTopicsRepo _repository;

  GeneratePracticeExamUseCase(this._repository);

  @override
  Future<ApiResult<PracticeExamGeneration>> call({
    GeneratePracticeExamParams? params,
  }) async {
    return await _repository.generatePracticeExam(
      studentId: params?.studentId ?? "",
      topicName: params?.topicName ?? "",
    );
  }
}
