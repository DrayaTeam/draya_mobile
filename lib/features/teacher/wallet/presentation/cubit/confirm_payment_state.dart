import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "confirm_payment_state.freezed.dart";

@freezed
abstract class ConfirmPaymentState with _$ConfirmPaymentState {
  const factory ConfirmPaymentState({
    @Default(CubitStatus.initial) CubitStatus status,
    ApiErrorModel? apiErrorModel,
  }) = _ConfirmPaymentState;
}
