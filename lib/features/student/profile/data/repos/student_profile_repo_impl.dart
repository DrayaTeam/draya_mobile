import "dart:io";

import "package:dio/dio.dart";
import "package:draya_mobile/core/networking/api_error_handler.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/auth/data/models/user_profile_model.dart";
import "package:draya_mobile/features/auth/data/source/auth_api_service.dart";
import "package:draya_mobile/features/student/profile/data/models/student_profile_model.dart";
import "package:draya_mobile/features/student/profile/data/models/update_student_profile_request_model.dart";
import "package:draya_mobile/features/student/profile/data/source/student_profile_api_service.dart";
import "package:draya_mobile/features/student/profile/domain/repos/student_profile_repo.dart";

class StudentProfileRepoImpl implements StudentProfileRepo {
  final StudentProfileApiService _studentProfileApiService;
  final AuthApiService _authApiService;

  StudentProfileRepoImpl(this._studentProfileApiService, this._authApiService);

  @override
  Future<ApiResult<StudentProfileModel>> getStudentProfile() async {
    try {
      final response = await _authApiService.getCurrentUserProfile();
      return ApiResult.success(response.toStudentProfileModel());
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<StudentProfileModel>> updateStudentProfile(
    UpdateStudentProfileRequestModel request,
  ) async {
    try {
      final response = await _studentProfileApiService.updateStudentProfile(
        request,
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<dynamic>> uploadProfilePicture(File file) async {
    try {
      final fileName = file.path.split("/").last.split("\\").last;
      final multipartFile = await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      );
      final response = await _studentProfileApiService.uploadProfilePicture(
        multipartFile,
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
