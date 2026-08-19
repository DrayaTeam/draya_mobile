import "package:draya_mobile/core/constants/app_shared_pref_keys.dart";
import "package:draya_mobile/core/helpers/app_shared_pref_helper.dart";
import "package:draya_mobile/core/helpers/app_token_helper.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/auth/data/models/auth_response_model.dart";
import "package:draya_mobile/features/auth/data/models/register_student_request_model.dart";
import "package:draya_mobile/features/auth/domain/usecases/student_register_use_case.dart";
import "package:draya_mobile/features/auth/presentation/student_signup/cubit/student_signup_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class StudentSignupCubit extends Cubit<StudentSignupState> {
  final StudentRegisterUseCase studentRegisterUseCase;
  StudentSignupCubit(this.studentRegisterUseCase)
    : super(const StudentSignupState.initial());

  Future<void> registerStudent({
    required RegisterStudentRequestModel registerStudentRequestModel,
  }) async {
    emit(const StudentSignupState.loading());
    final result = await studentRegisterUseCase.call(
      params: registerStudentRequestModel,
    );
    result.when(
      success: (authResponse) async {
        await AppTokenHelper.saveTokens(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
        );

        final role = authResponse.user?.role;

        if (role != null && role.isNotEmpty) {
          await AppSharedPrefHelper.setData(
            AppSharedPrefKeys.userRole,
            role,
          );
        }

        emit(
          StudentSignupState.success(
            authEntity: authResponse.toEntity(),
          ),
        );
      },
      failure: (error) =>
          emit(StudentSignupState.failure(apiErrorModel: error)),
    );
  }
}
