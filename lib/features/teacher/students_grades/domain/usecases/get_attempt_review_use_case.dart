import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/students_grades/data/models/attempt_review_models.dart";
import "package:draya_mobile/features/teacher/students_grades/domain/repos/students_grades_repo.dart";

class GetAttemptReviewUseCase {
  final StudentsGradesRepo _repo;

  GetAttemptReviewUseCase(this._repo);

  Future<ApiResult<AttemptReviewResultsModel>> call({
    required String attemptId,
  }) {
    return _repo.getAttemptResults(attemptId);
  }
}
