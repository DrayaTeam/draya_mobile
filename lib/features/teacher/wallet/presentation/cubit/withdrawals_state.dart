import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/withdrawal_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/withdrawal_paged_result_model.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "withdrawals_state.freezed.dart";

@freezed
abstract class WithdrawalsState with _$WithdrawalsState {
  const factory WithdrawalsState({
    @Default(CubitStatus.initial) CubitStatus status,
    WithdrawalPagedResultModel? withdrawalsResult,
    @Default(1) int currentPage,
    @Default(false) bool isPaginating,
    @Default(false) bool isSubmittingWithdrawal,
    WithdrawalModel? submittedWithdrawal,
    String? actionSuccessMessage,
    ApiErrorModel? apiErrorModel,
  }) = _WithdrawalsState;
}
