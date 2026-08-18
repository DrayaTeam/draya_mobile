import 'dart:io';

import 'package:draya_mobile/core/helpers/app_use_case.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/student/profile/domain/repos/student_profile_repo.dart';

class UploadStudentProfilePictureUseCase
    implements AppUseCase<ApiResult<dynamic>, File> {
  final StudentProfileRepo _studentProfileRepo;

  UploadStudentProfilePictureUseCase(this._studentProfileRepo);

  @override
  Future<ApiResult<dynamic>> call({File? params}) async {
    return await _studentProfileRepo.uploadProfilePicture(params!);
  }
}
