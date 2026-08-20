import "package:draya_mobile/core/networking/api_error_handler.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/sections/data/models/create_section_request_model.dart";
import "package:draya_mobile/features/teacher/sections/data/models/section_model.dart";
import "package:draya_mobile/features/teacher/sections/data/sources/section_api_service.dart";
import "package:draya_mobile/features/teacher/sections/domain/repos/section_repo.dart";

class SectionRepoImpl implements SectionRepo {
  final SectionApiService _sectionApiService;

  SectionRepoImpl(this._sectionApiService);

  @override
  Future<ApiResult<List<SectionModel>>> getSections({
    required String classroomId,
  }) async {
    try {
      final response = await _sectionApiService.getSections(classroomId);

      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<void>> createSection({
    required String classroomId,
    required CreateSectionRequestModel createSectionRequestModel,
  }) async {
    try {
      final response = await _sectionApiService.createSection(
        classroomId,
        createSectionRequestModel,
      );

      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<void>> deleteSection({required String sectionId}) async {
    try {
      final response = await _sectionApiService.deleteSection(sectionId);

      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
