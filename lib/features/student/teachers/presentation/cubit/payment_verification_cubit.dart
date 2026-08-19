import 'dart:async';

import 'package:draya_mobile/core/networking/api_result.dart';
import 'package:draya_mobile/features/student/teachers/domain/usecases/get_payment_status_use_case.dart';
import 'package:draya_mobile/features/student/teachers/presentation/cubit/payment_verification_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentVerificationCubit extends Cubit<PaymentVerificationState> {
  final GetPaymentStatusUseCase _getPaymentStatusUseCase;

  static const int maxRetryAttempts = 10;
  static const Duration retryDelay = Duration(seconds: 3);

  PaymentVerificationCubit(this._getPaymentStatusUseCase)
      : super(const PaymentVerificationState());

  Future<void> verifyPayment(String transactionId) async {
    if (transactionId.trim().isEmpty) {
      emit(
        state.copyWith(
          status: PaymentVerificationStatus.error,
          apiErrorModel: null,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: PaymentVerificationStatus.polling,
        retryCount: 0,
        apiErrorModel: null,
      ),
    );

    await _pollPaymentStatus(transactionId, attempt: 1);
  }

  Future<void> _pollPaymentStatus(
    String transactionId, {
    required int attempt,
  }) async {
    if (isClosed) return;

    final result = await _getPaymentStatusUseCase.call(params: transactionId);

    if (isClosed) return;

    await result.when(
      success: (paymentStatus) async {
        if (paymentStatus.isCompleted) {
          emit(
            state.copyWith(
              status: PaymentVerificationStatus.completed,
              paymentStatus: paymentStatus,
              retryCount: attempt,
            ),
          );
        } else if (paymentStatus.isPending) {
          if (attempt >= maxRetryAttempts) {
            emit(
              state.copyWith(
                status: PaymentVerificationStatus.timeout,
                paymentStatus: paymentStatus,
                retryCount: attempt,
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: PaymentVerificationStatus.polling,
                paymentStatus: paymentStatus,
                retryCount: attempt,
              ),
            );
            await Future.delayed(retryDelay);
            if (!isClosed) {
              await _pollPaymentStatus(transactionId, attempt: attempt + 1);
            }
          }
        } else {
          // Failed or other status
          emit(
            state.copyWith(
              status: PaymentVerificationStatus.failed,
              paymentStatus: paymentStatus,
              retryCount: attempt,
            ),
          );
        }
      },
      failure: (apiErrorModel) {
        emit(
          state.copyWith(
            status: PaymentVerificationStatus.error,
            apiErrorModel: apiErrorModel,
            retryCount: attempt,
          ),
        );
      },
    );
  }

  void reset() {
    emit(const PaymentVerificationState());
  }
}
