import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/subjects/data/models/add_subject_request_model.dart";
import "package:draya_mobile/features/teacher/subjects/data/models/subject_model.dart";

abstract class SubjectRepo {
  Future<ApiResult<List<SubjectModel>>> getSubjects();

  Future<ApiResult<SubjectModel>> addSubject({
    required AddSubjectRequestModel addSubjectRequestModel,
  });
}
