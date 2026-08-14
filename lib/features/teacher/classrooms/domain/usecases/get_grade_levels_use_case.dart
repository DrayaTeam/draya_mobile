import 'package:draya_mobile/core/helpers/app_use_case.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/teacher/classrooms/data/models/grade_level_model.dart';
import 'package:draya_mobile/features/teacher/classrooms/domain/repos/classroom_repo.dart';

class GetGradeLevelsUseCase
    implements AppUseCase<ApiResult<List<GradeLevelModel>>, void> {
  final ClassroomRepo _classroomRepo;

  GetGradeLevelsUseCase(this._classroomRepo);
  @override
  Future<ApiResult<List<GradeLevelModel>>> call({void params}) async {
    return await _classroomRepo.getGradeLevels();
  }
}
