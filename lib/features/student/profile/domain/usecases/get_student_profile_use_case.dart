import 'package:draya_mobile/core/helpers/app_use_case.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/student/profile/data/models/student_profile_model.dart';
import 'package:draya_mobile/features/student/profile/domain/repos/student_profile_repo.dart';

class GetStudentProfileUseCase
    implements AppUseCase<ApiResult<StudentProfileModel>, void> {
  final StudentProfileRepo _studentProfileRepo;

  GetStudentProfileUseCase(this._studentProfileRepo);

  @override
  Future<ApiResult<StudentProfileModel>> call({void params}) async {
    return await _studentProfileRepo.getStudentProfile();
  }
}
