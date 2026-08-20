import "package:dio/dio.dart";
import "package:draya_mobile/core/networking/api_constants.dart";
import "package:draya_mobile/features/student/teachers/data/models/classroom_checkout_response_model.dart";
import "package:draya_mobile/features/student/teachers/data/models/classroom_checkout_request_model.dart";
import "package:draya_mobile/features/student/teachers/data/models/payment_status_model.dart";
import "package:draya_mobile/features/student/teachers/data/models/teacher_classroom_paged_result_model.dart";
import "package:draya_mobile/features/student/teachers/data/models/teacher_model.dart";
import "package:draya_mobile/features/student/teachers/data/source/teacher_api_constants.dart";
import "package:retrofit/retrofit.dart";

part "teacher_api_service.g.dart";

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class TeacherApiService {
  factory TeacherApiService(Dio dio) = _TeacherApiService;

  @GET(TeacherApiConstants.teachers)
  Future<List<TeacherModel>> getTeachers();

  @GET(TeacherApiConstants.teacherClassrooms)
  Future<TeacherClassroomPagedResultModel> getTeacherClassrooms(
    @Path("teacherId") String teacherId,
    @Query("page") int page,
    @Query("pageSize") int pageSize,
  );

  @POST("/classrooms/{classroomId}/checkout")
  Future<ClassroomCheckoutResponseModel> checkoutClassroom(
    @Path("classroomId") String classroomId,
    @Body() ClassroomCheckoutRequestModel request,
  );

  @GET(TeacherApiConstants.paymentStatus)
  Future<PaymentStatusModel> getPaymentStatus(
    @Path("transactionId") String transactionId,
  );
}
