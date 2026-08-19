import "package:draya_mobile/core/constants/app_shared_pref_keys.dart";
import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/helpers/app_shared_pref_helper.dart";
import "package:draya_mobile/core/helpers/app_token_helper.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/auth/data/models/auth_response_model.dart";
import "package:draya_mobile/features/auth/data/models/login_request_model.dart";
import "package:draya_mobile/features/auth/domain/usecases/login_use_case.dart";
import "package:draya_mobile/features/auth/presentation/signin/cubit/signin_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class SigninCubit extends Cubit<SigninState> {
  final LoginUseCase loginUseCase;
  SigninCubit(this.loginUseCase) : super(const SigninState());

  Future<void> signin({required LoginRequestModel loginRequestModel}) async {
    emit(state.copyWith(status: CubitStatus.loading));
    final result = await loginUseCase.call(params: loginRequestModel);
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

        await AppSharedPrefHelper.setData(
          AppSharedPrefKeys.rememberMe,
          state.rememberMe,
        );

        emit(
          state.copyWith(
            status: CubitStatus.success,
            authEntity: authResponse.toEntity(),
          ),
        );
      },
      failure: (error) =>
          emit(state.copyWith(status: CubitStatus.error, apiErrorModel: error)),
    );
  }

  void toggleRememberMe() {
    emit(state.copyWith(rememberMe: !state.rememberMe));
  }
}
