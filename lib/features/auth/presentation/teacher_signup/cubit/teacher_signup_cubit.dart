import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/auth/data/models/auth_response_model.dart";
import "package:draya_mobile/features/auth/data/models/register_teacher_request_model.dart";
import "package:draya_mobile/features/auth/domain/usecases/teacher_register_use_case.dart";
import "package:draya_mobile/features/auth/presentation/teacher_signup/cubit/teacher_signup_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class TeacherSignupCubit extends Cubit<TeacherSignupState> {
  final TeacherRegisterUseCase teacherRegisterUseCase;
  TeacherSignupCubit(this.teacherRegisterUseCase)
    : super(const TeacherSignupState());

  Future<void> registerTeacher({
    required RegisterTeacherRequestModel registerTeacherRequestModel,
  }) async {
    emit(state.copyWith(status: CubitStatus.loading));

    final result = await teacherRegisterUseCase.call(
      params: registerTeacherRequestModel,
    );

    result.when(
      success: (authResponse) {
        emit(
          state.copyWith(
            status: CubitStatus.success,
            authEntity: authResponse.toEntity(),
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
