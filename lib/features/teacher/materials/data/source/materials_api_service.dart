import "package:dio/dio.dart";
import "package:draya_mobile/core/networking/api_constants.dart";
import "package:draya_mobile/features/teacher/materials/data/source/materials_api_constants.dart";
import "package:retrofit/retrofit.dart";

part "materials_api_service.g.dart";

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class MaterialsApiService {
  factory MaterialsApiService(Dio dio) = _MaterialsApiService;

  @POST(MaterialsApiConstants.uploadMaterial)
  Future<void> uploadMaterials(
    @Path(MaterialsApiConstants.sectionId) String sectionId,

    @Part(name: "title") String title,

    @Part(name: "materialType") String materialType,

    @Part(name: "file") MultipartFile file,
  );

  // @GET(MaterialsApiConstants.materials)
  // Future<TeacherMaterialPagedResultModel> getMaterials(
  //   @Path(MaterialsApiConstants.classroomId) String classroomId,
  //   @Query(MaterialsApiConstants.page) int page,
  //   @Query(MaterialsApiConstants.pageSize) int pageSize,
  // );
}
