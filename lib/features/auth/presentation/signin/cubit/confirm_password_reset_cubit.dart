import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/auth/data/models/confirm_password_reset_model.dart";
import "package:draya_mobile/features/auth/domain/usecases/confirm_password_reset_use_case.dart";
import "package:draya_mobile/features/auth/presentation/signin/cubit/confirm_password_reset_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ConfirmPasswordResetCubit extends Cubit<ConfirmPasswordResetState> {
  final ConfirmPasswordResetUseCase _confirmPasswordResetUseCase;

  ConfirmPasswordResetCubit(this._confirmPasswordResetUseCase)
    : super(const ConfirmPasswordResetState());

  Future<void> confirmPasswordReset({
    required ConfirmPasswordResetModel confirmPasswordResetModel,
  }) async {
    emit(state.copyWith(status: CubitStatus.loading));

    final result = await _confirmPasswordResetUseCase(
      params: confirmPasswordResetModel,
    );

    result.when(
      success: (nothing) {
        emit(state.copyWith(status: CubitStatus.success));
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
