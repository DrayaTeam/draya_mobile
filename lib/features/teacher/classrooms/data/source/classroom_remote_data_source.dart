import "package:dio/dio.dart";
import "package:draya_mobile/core/networking/api_constants.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/classroom_model.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/classroom_paged_result_model.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/classroom_pricing_model.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/classroom_type_model.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/create_classroom_request_model.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/grade_level_model.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/set_classroom_pricing_request_model.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/student_roster_paged_result_model.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/update_classroom_request_model.dart";
import "package:draya_mobile/features/teacher/classrooms/data/source/classroom_api_constants.dart";
import "package:retrofit/retrofit.dart";

part "classroom_remote_data_source.g.dart";

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ClassroomRemoteDataSource {
  factory ClassroomRemoteDataSource(Dio dio) = _ClassroomRemoteDataSource;

  @POST(ClassroomApiConstants.classrooms)
  Future<ClassroomModel> createClassroom(
    @Body() CreateClassroomRequestModel request,
  );

  @GET(ClassroomApiConstants.classrooms)
  Future<ClassroomPagedResultModel> getClassrooms();

  @GET(ClassroomApiConstants.classroomById)
  Future<ClassroomModel> getClassroomById(
    @Path("classroomId") String classroomId,
  );

  @PUT(ClassroomApiConstants.classroomById)
  Future<ClassroomModel> updateClassroom(
    @Path("classroomId") String classroomId,
    @Body() UpdateClassroomRequestModel request,
  );

  @DELETE(ClassroomApiConstants.classroomById)
  Future<void> deleteClassroom(
    @Path(ClassroomApiConstants.classroomId) String classroomId,
  );

  @POST(ClassroomApiConstants.regenerateCode)
  Future<ClassroomModel> regenerateClassroomCode(
    @Path("classroomId") String classroomId,
  );

  @GET(ClassroomApiConstants.students)
  Future<StudentRosterPagedResultModel> getClassroomStudents(
    @Path(ClassroomApiConstants.classroomId) String classroomId,
  );

  @PUT(ClassroomApiConstants.pricing)
  Future<ClassroomPricingModel> setClassroomPricing(
    @Path("classroomId") String classroomId,
    @Body() SetClassroomPricingRequestModel request,
  );

  @GET(ClassroomApiConstants.pricing)
  Future<ClassroomPricingModel> getClassroomPricing(
    @Path("classroomId") String classroomId,
  );

  @GET(ClassroomApiConstants.classroomTypes)
  Future<List<ClassroomTypeModel>> getClassroomTypes();

  @GET(ClassroomApiConstants.gradeLevels)
  Future<List<GradeLevelModel>> getGradeLevels();
}
