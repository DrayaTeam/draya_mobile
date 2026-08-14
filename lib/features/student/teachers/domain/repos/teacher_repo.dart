import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/student/teachers/data/models/teacher_classroom_paged_result_model.dart';
import 'package:draya_mobile/features/student/teachers/data/models/teacher_model.dart';

abstract class TeacherRepo {
  Future<ApiResult<List<TeacherModel>>> getTeachers();

  Future<ApiResult<TeacherClassroomPagedResultModel>> getTeacherClassrooms(
    String teacherId, {
    int page = 1,
    int pageSize = 20,
  });
}
