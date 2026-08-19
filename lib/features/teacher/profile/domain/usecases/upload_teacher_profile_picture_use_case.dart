import 'dart:io';

import 'package:draya_mobile/core/helpers/app_use_case.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/teacher/profile/domain/repos/teacher_profile_repo.dart';

class UploadTeacherProfilePictureUseCase
    implements AppUseCase<ApiResult<dynamic>, File> {
  final TeacherProfileRepo _teacherProfileRepo;

  UploadTeacherProfilePictureUseCase(this._teacherProfileRepo);

  @override
  Future<ApiResult<dynamic>> call({File? params}) async {
    return await _teacherProfileRepo.uploadProfilePicture(params!);
  }
}
