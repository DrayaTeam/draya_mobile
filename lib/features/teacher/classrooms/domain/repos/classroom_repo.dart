import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/classroom_model.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/classroom_paged_result_model.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/classroom_pricing_model.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/classroom_type_model.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/create_classroom_request_model.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/grade_level_model.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/set_classroom_pricing_request_model.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/student_roster_paged_result_model.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/update_classroom_request_model.dart";

abstract class ClassroomRepo {
  Future<ApiResult<ClassroomModel>> createClassroom(
    CreateClassroomRequestModel request,
  );

  Future<ApiResult<ClassroomPagedResultModel>> getClassrooms();

  Future<ApiResult<ClassroomModel>> getClassroomById(String classroomId);

  Future<ApiResult<ClassroomModel>> updateClassroom(
    String classroomId,
    UpdateClassroomRequestModel request,
  );

  Future<ApiResult<void>> deleteClassroom(String classroomId);

  Future<ApiResult<ClassroomModel>> regenerateClassroomCode(String classroomId);

  Future<ApiResult<StudentRosterPagedResultModel>> getClassroomStudents(
    String classroomId,
  );

  Future<ApiResult<ClassroomPricingModel>> setClassroomPricing(
    String classroomId,
    SetClassroomPricingRequestModel request,
  );

  Future<ApiResult<ClassroomPricingModel>> getClassroomPricing(
    String classroomId,
  );

  Future<ApiResult<List<ClassroomTypeModel>>> getClassroomTypes();

  Future<ApiResult<List<GradeLevelModel>>> getGradeLevels();
}
