import "package:draya_mobile/core/networking/api_error_handler.dart";
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
import "package:draya_mobile/features/teacher/classrooms/data/source/classroom_remote_data_source.dart";
import "package:draya_mobile/features/teacher/classrooms/domain/repos/classroom_repo.dart";

class ClassroomRepoImpl implements ClassroomRepo {
  final ClassroomRemoteDataSource _remoteDataSource;

  ClassroomRepoImpl(this._remoteDataSource);

  @override
  Future<ApiResult<ClassroomModel>> createClassroom(
    CreateClassroomRequestModel request,
  ) => _guard(() => _remoteDataSource.createClassroom(request));

  @override
  Future<ApiResult<ClassroomPagedResultModel>> getClassrooms() =>
      _guard(_remoteDataSource.getClassrooms);

  @override
  Future<ApiResult<ClassroomModel>> getClassroomById(String classroomId) =>
      _guard(() => _remoteDataSource.getClassroomById(classroomId));

  @override
  Future<ApiResult<ClassroomModel>> updateClassroom(
    String classroomId,
    UpdateClassroomRequestModel request,
  ) => _guard(() => _remoteDataSource.updateClassroom(classroomId, request));

  @override
  Future<ApiResult<void>> deleteClassroom(String classroomId) =>
      _guard(() => _remoteDataSource.deleteClassroom(classroomId));

  @override
  Future<ApiResult<ClassroomModel>> regenerateClassroomCode(
    String classroomId,
  ) => _guard(() => _remoteDataSource.regenerateClassroomCode(classroomId));

  @override
  Future<ApiResult<StudentRosterPagedResultModel>> getClassroomStudents(
    String classroomId,
  ) => _guard(() => _remoteDataSource.getClassroomStudents(classroomId));

  @override
  Future<ApiResult<ClassroomPricingModel>> setClassroomPricing(
    String classroomId,
    SetClassroomPricingRequestModel request,
  ) =>
      _guard(() => _remoteDataSource.setClassroomPricing(classroomId, request));

  @override
  Future<ApiResult<ClassroomPricingModel>> getClassroomPricing(
    String classroomId,
  ) => _guard(() => _remoteDataSource.getClassroomPricing(classroomId));

  @override
  Future<ApiResult<List<ClassroomTypeModel>>> getClassroomTypes() {
    return _guard(() => _remoteDataSource.getClassroomTypes());
  }

  @override
  Future<ApiResult<List<GradeLevelModel>>> getGradeLevels() {
    return _guard(() => _remoteDataSource.getGradeLevels());
  }

  @override
  Future<ApiResult<void>> deleteClassroomStudent({
    required String classroomId,
    required String studentId,
  }) async {
    return _guard(
      () => _remoteDataSource.deleteClassroomStudent(
        classroomId,
        studentId,
      ),
    );
  }

  Future<ApiResult<T>> _guard<T>(Future<T> Function() request) async {
    try {
      return ApiResult.success(await request());
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
