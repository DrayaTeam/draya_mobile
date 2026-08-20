import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/student_materials/domain/entity/classroom_section.dart";
import "package:draya_mobile/features/student/student_materials/domain/entity/material_stream.dart";
import "package:draya_mobile/features/student/student_materials/domain/entity/student_material.dart";

abstract class StudentMaterialsRepo {
  Future<ApiResult<StudentMaterialsPage>> getEnrolledMaterials({
    int page = 1,
    int pageSize = 20,
  });

  Future<ApiResult<StudentMaterialsPage>> getClassroomMaterials(
    String classroomId, {
    int page = 1,
    int pageSize = 20,
  });

  Future<ApiResult<List<ClassroomSection>>> getClassroomSections(
    String classroomId,
  );

  Future<ApiResult<MaterialStream>> getMaterialStream(String materialId);
}
