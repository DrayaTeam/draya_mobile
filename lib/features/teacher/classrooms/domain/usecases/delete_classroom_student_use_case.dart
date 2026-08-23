import "package:draya_mobile/core/helpers/app_use_case.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/classrooms/domain/repos/classroom_repo.dart";

class DeleteClassroomStudentUseCaseParams {
  final String classroomId;
  final String studentId;

  const DeleteClassroomStudentUseCaseParams({
    required this.classroomId,
    required this.studentId,
  });
}

class DeleteClassroomStudentUseCase
    implements
        AppUseCase<ApiResult<void>, DeleteClassroomStudentUseCaseParams> {
  final ClassroomRepo _classroomRepo;

  DeleteClassroomStudentUseCase(this._classroomRepo);

  @override
  Future<ApiResult<void>> call({
    DeleteClassroomStudentUseCaseParams? params,
  }) async {
    return await _classroomRepo.deleteClassroomStudent(
      classroomId: params!.classroomId,
      studentId: params.studentId,
    );
  }
}
