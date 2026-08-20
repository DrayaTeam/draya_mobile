import "dart:io";

import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/profile/data/models/update_student_profile_request_model.dart";
import "package:draya_mobile/features/student/profile/domain/usecases/get_student_profile_use_case.dart";
import "package:draya_mobile/features/student/profile/domain/usecases/update_student_profile_use_case.dart";
import "package:draya_mobile/features/student/profile/domain/usecases/upload_student_profile_picture_use_case.dart";
import "package:draya_mobile/features/student/profile/presentation/cubit/student_profile_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class StudentProfileCubit extends Cubit<StudentProfileState> {
  final GetStudentProfileUseCase _getStudentProfileUseCase;
  final UpdateStudentProfileUseCase _updateStudentProfileUseCase;
  final UploadStudentProfilePictureUseCase _uploadStudentProfilePictureUseCase;

  StudentProfileCubit(
    this._getStudentProfileUseCase,
    this._updateStudentProfileUseCase,
    this._uploadStudentProfilePictureUseCase,
  ) : super(const StudentProfileState());

  Future<void> getStudentProfile() async {
    emit(state.copyWith(status: CubitStatus.loading, apiErrorModel: null));

    final result = await _getStudentProfileUseCase.call();

    result.when(
      success: (data) {
        emit(
          state.copyWith(
            status: CubitStatus.success,
            studentProfile: data,
            apiErrorModel: null,
          ),
        );
      },
      failure: (apiErrorModel) {
        emit(
          state.copyWith(
            status: CubitStatus.error,
            apiErrorModel: apiErrorModel,
          ),
        );
      },
    );
  }

  Future<void> updateStudentProfile({
    required UpdateStudentProfileRequestModel request,
  }) async {
    emit(state.copyWith(status: CubitStatus.loading, apiErrorModel: null));

    final result = await _updateStudentProfileUseCase.call(
      params: request,
    );

    result.when(
      success: (data) {
        emit(
          state.copyWith(
            status: CubitStatus.success,
            studentProfile: data,
            apiErrorModel: null,
          ),
        );
      },
      failure: (apiErrorModel) {
        emit(
          state.copyWith(
            status: CubitStatus.error,
            apiErrorModel: apiErrorModel,
          ),
        );
      },
    );
  }

  Future<void> uploadProfilePicture({required File file}) async {
    emit(state.copyWith(isUploadingPicture: true, apiErrorModel: null));

    final result = await _uploadStudentProfilePictureUseCase.call(params: file);

    await result.when(
      success: (_) async {
        emit(state.copyWith(isUploadingPicture: false));
        await getStudentProfile();
      },
      failure: (apiErrorModel) {
        emit(
          state.copyWith(
            isUploadingPicture: false,
            apiErrorModel: apiErrorModel,
          ),
        );
      },
    );
  }
}
