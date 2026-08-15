import 'package:draya_mobile/core/helpers/app_use_case.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/auth/data/models/user_profile_model.dart';
import 'package:draya_mobile/features/auth/domain/repos/auth_repo.dart';

class GetCurrentUserProfileUseCase
    implements AppUseCase<ApiResult<UserProfileModel>, void> {
  final AuthRepo _authRepo;

  GetCurrentUserProfileUseCase(this._authRepo);

  @override
  Future<ApiResult<UserProfileModel>> call({void params}) async {
    return await _authRepo.getCurrentUserProfile();
  }
}
