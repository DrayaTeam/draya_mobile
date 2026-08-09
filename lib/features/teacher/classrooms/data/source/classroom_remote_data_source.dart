import 'package:dio/dio.dart';
import 'package:draya_mobile/core/networking/api_constants.dart';
import 'package:draya_mobile/features/teacher/classrooms/data/models/classroom_model.dart';
import 'package:draya_mobile/features/teacher/classrooms/data/models/classroom_paged_result_model.dart';
import 'package:draya_mobile/features/teacher/classrooms/data/models/classroom_pricing_model.dart';
import 'package:draya_mobile/features/teacher/classrooms/data/models/create_classroom_request_model.dart';
import 'package:draya_mobile/features/teacher/classrooms/data/models/set_classroom_pricing_request_model.dart';
import 'package:draya_mobile/features/teacher/classrooms/data/models/student_roster_paged_result_model.dart';
import 'package:draya_mobile/features/teacher/classrooms/data/models/update_classroom_request_model.dart';
import 'package:retrofit/retrofit.dart';

part 'classroom_remote_data_source.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ClassroomRemoteDataSource {
  factory ClassroomRemoteDataSource(Dio dio) = _ClassroomRemoteDataSource;

  @POST('/classrooms')
  Future<ClassroomModel> createClassroom(
    @Body() CreateClassroomRequestModel request,
  );

  @GET('/classrooms')
  Future<ClassroomPagedResultModel> getClassrooms();

  @GET('/classrooms/{classroomId}')
  Future<ClassroomModel> getClassroomById(
    @Path('classroomId') String classroomId,
  );

  @PUT('/classrooms/{classroomId}')
  Future<ClassroomModel> updateClassroom(
    @Path('classroomId') String classroomId,
    @Body() UpdateClassroomRequestModel request,
  );

  @DELETE('/classrooms/{classroomId}')
  Future<void> deleteClassroom(@Path('classroomId') String classroomId);

  @POST('/classrooms/{classroomId}/regenerate-code')
  Future<ClassroomModel> regenerateClassroomCode(
    @Path('classroomId') String classroomId,
  );

  @GET('/classrooms/{classroomId}/students')
  Future<StudentRosterPagedResultModel> getClassroomStudents(
    @Path('classroomId') String classroomId,
  );

  @PUT('/classrooms/{classroomId}/pricing')
  Future<ClassroomPricingModel> setClassroomPricing(
    @Path('classroomId') String classroomId,
    @Body() SetClassroomPricingRequestModel request,
  );

  @GET('/classrooms/{classroomId}/pricing')
  Future<ClassroomPricingModel> getClassroomPricing(
    @Path('classroomId') String classroomId,
  );
}
