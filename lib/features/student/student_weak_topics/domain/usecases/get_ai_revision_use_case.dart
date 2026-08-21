import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/student_weak_topics/domain/entity/ai_revision.dart";
import "package:draya_mobile/features/student/student_weak_topics/domain/repos/student_weak_topics_repo.dart";

class GetAiRevisionParams {
  final String studentId;
  final String topicName;

  const GetAiRevisionParams({
    required this.studentId,
    required this.topicName,
  });
}

class GetAiRevisionUseCase
    implements AppUseCase<ApiResult<AiRevision>, GetAiRevisionParams> {
  final StudentWeakTopicsRepo _repository;

  GetAiRevisionUseCase(this._repository);

  @override
  Future<ApiResult<AiRevision>> call({GetAiRevisionParams? params}) async {
    return await _repository.getAiRevision(
      studentId: params?.studentId ?? "",
      topicName: params?.topicName ?? "",
    );
  }
}
