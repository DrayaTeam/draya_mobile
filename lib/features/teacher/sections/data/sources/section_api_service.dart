import "package:dio/dio.dart";
import "package:draya_mobile/core/networking/api_constants.dart";
import "package:draya_mobile/features/teacher/sections/data/models/create_section_request_model.dart";
import "package:draya_mobile/features/teacher/sections/data/models/section_model.dart";
import "package:draya_mobile/features/teacher/sections/data/sources/section_api_constants.dart";
import "package:retrofit/retrofit.dart";

part "section_api_service.g.dart";

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class SectionApiService {
  factory SectionApiService(Dio dio) = _SectionApiService;

  @GET(SectionApiConstants.sections)
  Future<List<SectionModel>> getSections(
    @Path(SectionApiConstants.classroomId) String classroomId,
  );

  @POST(SectionApiConstants.sections)
  Future<void> createSection(
    @Path(SectionApiConstants.classroomId) String classroomId,
    @Body() CreateSectionRequestModel createSectionRequestModel,
  );

  @DELETE(SectionApiConstants.deleteSection)
  Future<void> deleteSection(
    @Path(SectionApiConstants.sectionId) String sectionId,
  );
}
