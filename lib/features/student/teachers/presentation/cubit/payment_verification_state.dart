import 'package:draya_mobile/core/networking/api_error_model.dart';
import 'package:draya_mobile/features/student/teachers/data/models/payment_status_model.dart';

enum PaymentVerificationStatus {
  initial,
  polling,
  completed,
  failed,
  timeout,
  error,
}

class PaymentVerificationState {
  final PaymentVerificationStatus status;
  final PaymentStatusModel? paymentStatus;
  final ApiErrorModel? apiErrorModel;
  final int retryCount;

  const PaymentVerificationState({
    this.status = PaymentVerificationStatus.initial,
    this.paymentStatus,
    this.apiErrorModel,
    this.retryCount = 0,
  });

  PaymentVerificationState copyWith({
    PaymentVerificationStatus? status,
    PaymentStatusModel? paymentStatus,
    ApiErrorModel? apiErrorModel,
    int? retryCount,
  }) {
    return PaymentVerificationState(
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      apiErrorModel: apiErrorModel ?? this.apiErrorModel,
      retryCount: retryCount ?? this.retryCount,
    );
  }
}
