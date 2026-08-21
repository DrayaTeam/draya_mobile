import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/transaction_paged_result_model.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "transactions_state.freezed.dart";

@freezed
abstract class TransactionsState with _$TransactionsState {
  const factory TransactionsState({
    @Default(CubitStatus.initial) CubitStatus status,
    TransactionPagedResultModel? transactionsResult,
    @Default(1) int currentPage,
    @Default(false) bool isPaginating,
    ApiErrorModel? apiErrorModel,
  }) = _TransactionsState;
}
