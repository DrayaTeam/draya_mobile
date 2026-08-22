import "dart:io";

import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/profile/data/models/update_teacher_request_model.dart";
import "package:draya_mobile/features/teacher/profile/domain/usecases/get_teacher_profile_use_case.dart";
import "package:draya_mobile/features/teacher/profile/domain/usecases/update_teacher_profile_use_case.dart";
import "package:draya_mobile/features/teacher/profile/domain/usecases/upload_teacher_profile_picture_use_case.dart";
import "package:draya_mobile/features/teacher/profile/presentation/cubit/teacher_profile_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class TeacherProfileCubit extends Cubit<TeacherProfileState> {
  final GetTeacherProfileUseCase _getTeacherProfileUseCase;
  final UploadTeacherProfilePictureUseCase _uploadTeacherProfilePictureUseCase;
  final UpdateTeacherProfileUseCase _updateTeacherProfileUseCase;

  TeacherProfileCubit(
    this._getTeacherProfileUseCase,
    this._uploadTeacherProfilePictureUseCase,
    this._updateTeacherProfileUseCase,
  ) : super(const TeacherProfileState());

  Future<void> getTeacherProfile() async {
    emit(
      state.copyWith(
        getTeacherProfileStatus: CubitStatus.loading,
        updateTeacherProfileStatus: CubitStatus.initial,
        isUploadingPicture: false,
        apiErrorModel: null,
      ),
    );

    final result = await _getTeacherProfileUseCase.call();

    result.when(
      success: (data) {
        emit(
          state.copyWith(
            getTeacherProfileStatus: CubitStatus.success,
            updateTeacherProfileStatus: CubitStatus.initial,
            isUploadingPicture: false,
            teacher: data,
            apiErrorModel: null,
          ),
        );
      },
      failure: (apiErrorModel) {
        emit(
          state.copyWith(
            getTeacherProfileStatus: CubitStatus.error,
            updateTeacherProfileStatus: CubitStatus.initial,
            isUploadingPicture: false,
            apiErrorModel: apiErrorModel,
          ),
        );
      },
    );
  }

  Future<void> uploadProfilePicture({required File file}) async {
    emit(state.copyWith(isUploadingPicture: true, apiErrorModel: null));

    final result = await _uploadTeacherProfilePictureUseCase.call(params: file);

    await result.when(
      success: (_) async {
        emit(
          state.copyWith(
            isUploadingPicture: false,
            getTeacherProfileStatus: CubitStatus.initial,
            updateTeacherProfileStatus: CubitStatus.initial,
          ),
        );
        await getTeacherProfile();
      },
      failure: (apiErrorModel) {
        emit(
          state.copyWith(
            isUploadingPicture: false,
            getTeacherProfileStatus: CubitStatus.initial,
            updateTeacherProfileStatus: CubitStatus.initial,
            apiErrorModel: apiErrorModel,
          ),
        );
      },
    );
  }

  Future<void> updateTeacherProfile({
    required UpdateTeacherRequestModel updateTeacherRequestModel,
  }) async {
    emit(state.copyWith(updateTeacherProfileStatus: CubitStatus.loading));

    final result = await _updateTeacherProfileUseCase.call(
      params: updateTeacherRequestModel,
    );

    await result.when(
      success: (nothing) async {
        emit(
          state.copyWith(
            updateTeacherProfileStatus: CubitStatus.success,
            getTeacherProfileStatus: CubitStatus.initial,
            isUploadingPicture: false,
          ),
        );
        await getTeacherProfile();
      },
      failure: (apiErrorModel) {
        emit(
          state.copyWith(
            updateTeacherProfileStatus: CubitStatus.error,
            getTeacherProfileStatus: CubitStatus.initial,
            isUploadingPicture: false,
          ),
        );
      },
    );
  }
}
