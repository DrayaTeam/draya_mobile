import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/auth/data/models/auth_response_model.dart";
import "package:draya_mobile/features/auth/data/models/register_student_request_model.dart";
import "package:draya_mobile/features/auth/domain/usecases/student_register_use_case.dart";
import "package:draya_mobile/features/auth/presentation/student_signup/cubit/student_signup_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class StudentSignupCubit extends Cubit<StudentSignupState> {
  final StudentRegisterUseCase studentRegisterUseCase;
  StudentSignupCubit(this.studentRegisterUseCase)
    : super(const StudentSignupState());

  Future<void> registerStudent({
    required RegisterStudentRequestModel registerStudentRequestModel,
  }) async {
    emit(state.copyWith(status: CubitStatus.loading));
    final result = await studentRegisterUseCase.call(
      params: registerStudentRequestModel,
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
