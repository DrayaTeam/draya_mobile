import "package:dio/dio.dart";
import "package:draya_mobile/core/networking/api_constants.dart";
import "package:draya_mobile/features/student/student_materials/data/models/material_stream_model.dart";
import "package:draya_mobile/features/student/student_materials/data/models/student_material_paged_result_model.dart";
import "package:draya_mobile/features/student/student_materials/data/source/student_materials_api_constants.dart";
import "package:retrofit/retrofit.dart";

part "student_materials_api_service.g.dart";

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class StudentMaterialsApiService {
  factory StudentMaterialsApiService(Dio dio) = _StudentMaterialsApiService;

  @GET(StudentMaterialsApiConstants.enrolledMaterials)
  Future<StudentMaterialPagedResultModel> getEnrolledMaterials({
    @Query("page") int page = 1,
    @Query("pageSize") int pageSize = 20,
  });

  @GET(StudentMaterialsApiConstants.classroomMaterials)
  Future<StudentMaterialPagedResultModel> getClassroomMaterials(
    @Path(StudentMaterialsApiConstants.classroomId) String classroomId, {
    @Query("page") int page = 1,
    @Query("pageSize") int pageSize = 20,
  });

  // @GET(StudentMaterialsApiConstants.classroomSections)
  // Future<List<ClassroomSectionModel>> getClassroomSections(
  //   @Path(StudentMaterialsApiConstants.classroomId) String classroomId,
  // );

  @GET(StudentMaterialsApiConstants.materialStream)
  Future<MaterialStreamModel> getMaterialStream(
    @Path(StudentMaterialsApiConstants.materialId) String materialId,
  );
}
