import 'package:draya_mobile/core/networking/api_error_handler.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/student/teachers/data/models/classroom_checkout_response_model.dart';
import 'package:draya_mobile/features/student/teachers/data/models/teacher_classroom_paged_result_model.dart';
import 'package:draya_mobile/features/student/teachers/data/models/teacher_model.dart';
import 'package:draya_mobile/features/student/teachers/data/source/teacher_api_service.dart';
import 'package:draya_mobile/features/student/teachers/domain/repos/teacher_repo.dart';

class TeacherRepoImpl implements TeacherRepo {
  final TeacherApiService _teacherApiService;

  TeacherRepoImpl(this._teacherApiService);

  @override
  Future<ApiResult<List<TeacherModel>>> getTeachers() async {
    try {
      final response = await _teacherApiService.getTeachers();
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<TeacherClassroomPagedResultModel>> getTeacherClassrooms(
    String teacherId, {
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _teacherApiService.getTeacherClassrooms(
        teacherId,
        page,
        pageSize,
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<ClassroomCheckoutResponseModel>> checkoutClassroom(
    String classroomId,
  ) async {
    try {
      final response = await _teacherApiService.checkoutClassroom(classroomId);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
