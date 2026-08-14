import 'package:draya_mobile/core/helpers/app_use_case.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/student/teachers/data/models/teacher_classroom_paged_result_model.dart';
import 'package:draya_mobile/features/student/teachers/domain/repos/teacher_repo.dart';

class TeacherClassroomsParams {
  final String teacherId;
  final int page;
  final int pageSize;

  const TeacherClassroomsParams({
    required this.teacherId,
    this.page = 1,
    this.pageSize = 20,
  });
}

class GetTeacherClassroomsUseCase
    implements
        AppUseCase<
          ApiResult<TeacherClassroomPagedResultModel>,
          TeacherClassroomsParams
        > {
  final TeacherRepo _teacherRepo;

  GetTeacherClassroomsUseCase(this._teacherRepo);

  @override
  Future<ApiResult<TeacherClassroomPagedResultModel>> call({
    TeacherClassroomsParams? params,
  }) async {
    final request = params ??
        const TeacherClassroomsParams(
          teacherId: '',
          page: 1,
          pageSize: 20,
        );

    return _teacherRepo.getTeacherClassrooms(
      request.teacherId,
      page: request.page,
      pageSize: request.pageSize,
    );
  }
}
