import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "confirm_password_reset_state.freezed.dart";

@freezed
abstract class ConfirmPasswordResetState with _$ConfirmPasswordResetState {
  const factory ConfirmPasswordResetState({
    @Default(CubitStatus.initial) CubitStatus status,
    ApiErrorModel? apiErrorModel,
  }) = _ConfirmPasswordResetState;
}
