import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/sections/data/models/create_section_request_model.dart";
import "package:draya_mobile/features/teacher/sections/data/models/section_model.dart";

abstract interface class SectionRepo {
  Future<ApiResult<List<SectionModel>>> getSections({
    required String classroomId,
  });

  Future<ApiResult<void>> createSection({
    required String classroomId,
    required CreateSectionRequestModel createSectionRequestModel,
  });

  Future<ApiResult<void>> deleteSection({
    required String sectionId,
  });
}
