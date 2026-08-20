import "package:dio/dio.dart";
import "package:draya_mobile/core/networking/api_constants.dart";
import "package:draya_mobile/features/teacher/materials/data/models/teacher_material_paged_result_model.dart";
import "package:draya_mobile/features/teacher/materials/data/source/materials_api_constants.dart";
import "package:retrofit/retrofit.dart";

part "materials_api_service.g.dart";

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class MaterialsApiService {
  factory MaterialsApiService(Dio dio) = _MaterialsApiService;

  @POST(MaterialsApiConstants.materials)
  Future<void> uploadMaterials(
    @Path(MaterialsApiConstants.classroomId) String classroomId,

    @Part(name: "title") String title,

    @Part(name: "materialType") String materialType,

    @Part(name: "file") MultipartFile file,
  );

  @GET(MaterialsApiConstants.materials)
  Future<TeacherMaterialPagedResultModel> getMaterials(
    @Path(MaterialsApiConstants.classroomId) String classroomId,
    @Query(MaterialsApiConstants.page) int page,
    @Query(MaterialsApiConstants.pageSize) int pageSize,
  );
}
