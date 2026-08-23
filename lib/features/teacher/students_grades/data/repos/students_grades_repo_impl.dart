import "package:draya_mobile/core/networking/api_error_handler.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/students_grades/data/models/exam_attempts_paged_result_model.dart";
import "package:draya_mobile/features/teacher/students_grades/data/source/students_grades_remote_data_source.dart";
import "package:draya_mobile/features/teacher/students_grades/domain/repos/students_grades_repo.dart";

class StudentsGradesRepoImpl implements StudentsGradesRepo {
  final StudentsGradesRemoteDataSource _remoteDataSource;

  StudentsGradesRepoImpl(this._remoteDataSource);

  @override
  Future<ApiResult<ExamAttemptsPagedResultModel>> getExamAttempts({
    required String examId,
    required int page,
    int pageSize = 10,
  }) => _guard(
        () => _remoteDataSource.getExamAttempts(
          examId,
          page: page,
          pageSize: pageSize,
        ),
      );

  Future<ApiResult<T>> _guard<T>(Future<T> Function() request) async {
    try {
      return ApiResult.success(await request());
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
