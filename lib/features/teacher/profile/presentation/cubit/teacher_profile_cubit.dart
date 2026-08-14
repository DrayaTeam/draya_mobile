import 'package:draya_mobile/core/enums/cubit_status.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/teacher/profile/domain/usecases/get_teacher_profile_use_case.dart';
import 'package:draya_mobile/features/teacher/profile/presentation/cubit/teacher_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherProfileCubit extends Cubit<TeacherProfileState> {
  final GetTeacherProfileUseCase _getTeacherProfileUseCase;

  TeacherProfileCubit(this._getTeacherProfileUseCase)
    : super(const TeacherProfileState());

  Future<void> getTeacherProfile() async {
    emit(state.copyWith(status: CubitStatus.loading));

    final result = await _getTeacherProfileUseCase.call();

    result.when(
      success: (data) {
        emit(
          state.copyWith(
            status: CubitStatus.success,
            teacher: data,
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
}
