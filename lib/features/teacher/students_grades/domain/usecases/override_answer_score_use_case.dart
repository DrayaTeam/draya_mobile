import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/students_grades/domain/repos/students_grades_repo.dart";
import "package:draya_mobile/features/teacher/students_grades/domain/usecases/override_answer_score_params.dart";

class OverrideAnswerScoreUseCase {
  final StudentsGradesRepo _repo;

  OverrideAnswerScoreUseCase(this._repo);

  Future<ApiResult<void>> call(OverrideAnswerScoreParams params) {
    return _repo.overrideAnswerScore(
      attemptId: params.attemptId,
      answerId: params.answerId,
      newScore: params.newScore,
    );
  }
}
