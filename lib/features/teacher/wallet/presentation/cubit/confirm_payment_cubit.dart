import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/wallet/domain/usecases/confirm_payment_use_case.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/confirm_payment_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ConfirmPaymentCubit extends Cubit<ConfirmPaymentState> {
  final ConfirmPaymentUseCase _confirmPaymentUseCase;

  ConfirmPaymentCubit(this._confirmPaymentUseCase)
      : super(const ConfirmPaymentState());

  Future<void> confirmPayment({
    required String paymentId,
    bool isSuccess = true,
  }) async {
    emit(state.copyWith(status: CubitStatus.loading));

    final result = await _confirmPaymentUseCase.call(
      params: ConfirmPaymentParams(
        paymentId: paymentId,
        isSuccess: isSuccess,
      ),
    );

    result.when(
      success: (_) {
        emit(
          state.copyWith(
            status: CubitStatus.success,
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
