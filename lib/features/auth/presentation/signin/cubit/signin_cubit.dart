import "package:draya_mobile/core/constants/app_shared_pref_keys.dart";
import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/helpers/app_shared_pref_helper.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/auth/data/models/auth_response_model.dart";
import "package:draya_mobile/features/auth/data/models/login_request_model.dart";
import "package:draya_mobile/features/auth/data/models/request_password_reset_model.dart";
import "package:draya_mobile/features/auth/domain/usecases/login_use_case.dart";
import "package:draya_mobile/features/auth/domain/usecases/request_password_reset_use_case.dart";
import "package:draya_mobile/features/auth/presentation/signin/cubit/signin_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class SigninCubit extends Cubit<SigninState> {
  final LoginUseCase loginUseCase;
  final RequestPasswordResetUseCase _requestPasswordResetUseCase;

  SigninCubit(
    this.loginUseCase,
    this._requestPasswordResetUseCase,
  ) : super(const SigninState());

  Future<void> signin({required LoginRequestModel loginRequestModel}) async {
    emit(
      state.copyWith(
        signinStatus: CubitStatus.loading,
        requestPasswordResetStatus: CubitStatus.initial,
      ),
    );
    final result = await loginUseCase.call(params: loginRequestModel);
    result.when(
      success: (authResponse) async {
        await AppSharedPrefHelper.setData(
          AppSharedPrefKeys.rememberMe,
          state.rememberMe,
        );

        emit(
          state.copyWith(
            signinStatus: CubitStatus.success,
            requestPasswordResetStatus: CubitStatus.initial,
            authEntity: authResponse.toEntity(),
          ),
        );
      },
      failure: (error) => emit(
        state.copyWith(
          signinStatus: CubitStatus.error,
          requestPasswordResetStatus: CubitStatus.initial,
          apiErrorModel: error,
        ),
      ),
    );
  }

  void toggleRememberMe() {
    emit(state.copyWith(rememberMe: !state.rememberMe));
  }

  Future<void> requestPasswordReset({
    required RequestPasswordResetModel requestPasswordResetModel,
  }) async {
    emit(
      state.copyWith(
        requestPasswordResetStatus: CubitStatus.loading,
        signinStatus: CubitStatus.initial,
      ),
    );

    final result = await _requestPasswordResetUseCase(
      params: requestPasswordResetModel,
    );

    result.when(
      success: (nothing) {
        emit(
          state.copyWith(
            requestPasswordResetStatus: CubitStatus.success,
            signinStatus: CubitStatus.initial,
          ),
        );
      },
      failure: (apiErrorModel) {
        emit(
          state.copyWith(
            requestPasswordResetStatus: CubitStatus.error,
            signinStatus: CubitStatus.initial,
            apiErrorModel: apiErrorModel,
          ),
        );
      },
    );
  }
}
