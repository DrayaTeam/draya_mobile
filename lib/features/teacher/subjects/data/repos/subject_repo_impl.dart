import "package:draya_mobile/core/networking/api_error_handler.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/subjects/data/models/add_subject_request_model.dart";
import "package:draya_mobile/features/teacher/subjects/data/models/subject_model.dart";
import "package:draya_mobile/features/teacher/subjects/data/source/subject_api_service.dart";
import "package:draya_mobile/features/teacher/subjects/domain/repos/subject_repo.dart";

class SubjectRepoImpl implements SubjectRepo {
  final SubjectApiService _subjectApiService;

  SubjectRepoImpl(this._subjectApiService);

  @override
  Future<ApiResult<SubjectModel>> addSubject({
    required AddSubjectRequestModel addSubjectRequestModel,
  }) async {
    try {
      final response = await _subjectApiService.addSubject(
        addSubjectRequestModel,
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<List<SubjectModel>>> getSubjects() async {
    try {
      final response = await _subjectApiService.getSubjects();
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
