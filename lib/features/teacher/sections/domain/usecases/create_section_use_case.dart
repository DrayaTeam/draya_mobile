import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/sections/data/models/create_section_request_model.dart";
import "package:draya_mobile/features/teacher/sections/domain/repos/section_repo.dart";

class CreateSectionUseCaseParams {
  final String classroomId;
  final CreateSectionRequestModel createSectionRequestModel;

  const CreateSectionUseCaseParams({
    required this.classroomId,
    required this.createSectionRequestModel,
  });
}

class CreateSectionUseCase
    implements AppUseCase<ApiResult<void>, CreateSectionUseCaseParams> {
  final SectionRepo _sectionRepo;

  CreateSectionUseCase(this._sectionRepo);

  @override
  Future<ApiResult<void>> call({CreateSectionUseCaseParams? params}) async {
    return await _sectionRepo.createSection(
      classroomId: params!.classroomId,
      createSectionRequestModel: params.createSectionRequestModel,
    );
  }
}
