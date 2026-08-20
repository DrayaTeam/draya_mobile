import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/sections/data/models/section_model.dart";
import "package:draya_mobile/features/teacher/sections/domain/repos/section_repo.dart";

class GetSectionsUseCase
    implements AppUseCase<ApiResult<List<SectionModel>>, String> {
  final SectionRepo _sectionRepo;

  GetSectionsUseCase(this._sectionRepo);

  @override
  Future<ApiResult<List<SectionModel>>> call({String? params}) async {
    return await _sectionRepo.getSections(classroomId: params!);
  }
}
