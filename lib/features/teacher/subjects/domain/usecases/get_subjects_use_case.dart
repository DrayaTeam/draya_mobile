import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/subjects/data/models/subject_model.dart";
import "package:draya_mobile/features/teacher/subjects/domain/repos/subject_repo.dart";

class GetSubjectsUseCase
    implements AppUseCase<ApiResult<List<SubjectModel>>, void> {
  final SubjectRepo _subjectRepo;

  GetSubjectsUseCase(this._subjectRepo);

  @override
  Future<ApiResult<List<SubjectModel>>> call({void params}) async {
    return await _subjectRepo.getSubjects();
  }
}
