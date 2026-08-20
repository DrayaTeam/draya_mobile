import "dart:io";

import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/profile/domain/usecases/get_teacher_profile_use_case.dart";
import "package:draya_mobile/features/teacher/profile/domain/usecases/upload_teacher_profile_picture_use_case.dart";
import "package:draya_mobile/features/teacher/profile/presentation/cubit/teacher_profile_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class TeacherProfileCubit extends Cubit<TeacherProfileState> {
  final GetTeacherProfileUseCase _getTeacherProfileUseCase;
  final UploadTeacherProfilePictureUseCase _uploadTeacherProfilePictureUseCase;

  TeacherProfileCubit(
    this._getTeacherProfileUseCase,
    this._uploadTeacherProfilePictureUseCase,
  ) : super(const TeacherProfileState());

  Future<void> getTeacherProfile() async {
    emit(state.copyWith(status: CubitStatus.loading, apiErrorModel: null));

    final result = await _getTeacherProfileUseCase.call();

    result.when(
      success: (data) {
        emit(
          state.copyWith(
            status: CubitStatus.success,
            teacher: data,
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

    final result = await _uploadTeacherProfilePictureUseCase.call(params: file);

    await result.when(
      success: (_) async {
        emit(state.copyWith(isUploadingPicture: false));
        await getTeacherProfile();
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
