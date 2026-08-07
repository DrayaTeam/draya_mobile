import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/auth/data/models/auth_response_model.dart';
import 'package:draya_mobile/features/auth/data/models/register_teacher_request_model.dart';
import 'package:draya_mobile/features/auth/domain/usecases/teacher_register_use_case.dart';
import 'package:draya_mobile/features/auth/presentation/teacher_signup/cubit/teacher_signup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherSignupCubit extends Cubit<TeacherSignupState> {
  final TeacherRegisterUseCase teacherRegisterUseCase;
  TeacherSignupCubit(this.teacherRegisterUseCase)
    : super(const TeacherSignupState.initial());

  Future<void> registerTeacher({
    required RegisterTeacherRequestModel registerTeacherRequestModel,
  }) async {
    emit(const TeacherSignupState.loading());
    final result = await teacherRegisterUseCase.call(
      params: registerTeacherRequestModel,
    );
    result.when(
      success: (authResponse) =>
          emit(TeacherSignupState.success(authEntity: authResponse.toEntity())),
      failure: (error) =>
          emit(TeacherSignupState.failure(apiErrorModel: error)),
    );
  }
}
