import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/sections/domain/repos/section_repo.dart";

class DeleteSectionUseCase implements AppUseCase<ApiResult<void>, String> {
  final SectionRepo _sectionRepo;

  DeleteSectionUseCase(this._sectionRepo);

  @override
  Future<ApiResult<void>> call({String? params}) async {
    return await _sectionRepo.deleteSection(sectionId: params!);
  }
}
