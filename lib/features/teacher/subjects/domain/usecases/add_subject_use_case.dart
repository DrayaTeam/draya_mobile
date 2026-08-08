import 'package:draya_mobile/core/helpers/app_use_case.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/teacher/subjects/data/models/add_subject_request_model.dart';
import 'package:draya_mobile/features/teacher/subjects/data/models/subject_model.dart';
import 'package:draya_mobile/features/teacher/subjects/domain/repos/subject_repo.dart';

class AddSubjectUseCase
    implements AppUseCase<ApiResult<SubjectModel>, AddSubjectRequestModel> {
  final SubjectRepo _subjectRepo;

  AddSubjectUseCase(this._subjectRepo);

  @override
  Future<ApiResult<SubjectModel>> call({AddSubjectRequestModel? params}) async {
    return await _subjectRepo.addSubject(addSubjectRequestModel: params!);
  }
}
