import 'package:draya_mobile/core/enums/cubit_status.dart';
import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/auth/data/models/auth_response_model.dart';
import 'package:draya_mobile/features/auth/data/models/login_request_model.dart';
import 'package:draya_mobile/features/auth/domain/usecases/login_use_case.dart';
import 'package:draya_mobile/features/auth/presentation/signin/cubit/signin_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninCubit extends Cubit<SigninState> {
  final LoginUseCase loginUseCase;
  SigninCubit(this.loginUseCase) : super(const SigninState());

  Future<void> signin({required LoginRequestModel loginRequestModel}) async {
    emit(state.copyWith(status: CubitStatus.loading));
    final result = await loginUseCase.call(params: loginRequestModel);
    result.when(
      success: (authResponse) => emit(
        state.copyWith(
          status: CubitStatus.success,
          authEntity: authResponse.toEntity(),
        ),
      ),
      failure: (error) =>
          emit(state.copyWith(status: CubitStatus.error, apiErrorModel: error)),
    );
  }

  void toggleRememberMe() {
    emit(state.copyWith(rememberMe: !state.rememberMe));
  }
}
