import 'package:dio/dio.dart';
import 'package:draya_mobile/core/networking/api_constants.dart';
import 'package:draya_mobile/features/student/student_materials/data/models/classroom_section_model.dart';
import 'package:draya_mobile/features/student/student_materials/data/source/student_materials_api_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'student_classrooms_sections_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrlWithoutV1)
abstract class StudentClassroomSectionsApiService {
  factory StudentClassroomSectionsApiService(Dio dio) = _StudentClassroomSectionsApiService;

  @GET(StudentMaterialsApiConstants.classroomSections)
  Future<List<ClassroomSectionModel>> getClassroomSections(
    @Path(StudentMaterialsApiConstants.classroomId) String classroomId,
  );
}