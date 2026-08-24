import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/exams/domain/entity/student_exam.dart";
import "package:draya_mobile/features/student/exams/domain/repos/student_exam_repo.dart";

class GetStudentExamsUseCase
    implements AppUseCase<ApiResult<List<StudentExamOverview>>, Object?> {
  final StudentExamRepo _repo;

  GetStudentExamsUseCase(this._repo);

  @override
  Future<ApiResult<List<StudentExamOverview>>> call({Object? params}) {
    return _repo.getStudentExams();
  }
}
