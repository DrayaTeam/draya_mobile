import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/transaction_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/transaction_paged_result_model.dart";
import "package:draya_mobile/features/teacher/wallet/domain/usecases/get_transactions_use_case.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/transactions_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class TransactionsCubit extends Cubit<TransactionsState> {
  final GetTransactionsUseCase _getTransactionsUseCase;

  TransactionsCubit(this._getTransactionsUseCase)
      : super(const TransactionsState());

  Future<void> getTransactions({bool isRefresh = false}) async {
    if (isRefresh) {
      emit(
        state.copyWith(
          status: CubitStatus.loading,
          currentPage: 1,
        ),
      );
    } else {
      if (state.transactionsResult == null) {
        emit(state.copyWith(status: CubitStatus.loading));
      }
    }

    final result = await _getTransactionsUseCase.call(
      params: const GetTransactionsParams(pageNumber: 1, pageSize: 20),
    );

    result.when(
      success: (pagedResult) {
        emit(
          state.copyWith(
            status: CubitStatus.success,
            transactionsResult: pagedResult,
            currentPage: 1,
            isPaginating: false,
          ),
        );
      },
      failure: (apiErrorModel) {
        emit(
          state.copyWith(
            status: CubitStatus.error,
            apiErrorModel: apiErrorModel,
            isPaginating: false,
          ),
        );
      },
    );
  }

  Future<void> loadMoreTransactions() async {
    final currentResult = state.transactionsResult;
    if (currentResult == null ||
        !currentResult.hasNextPage ||
        state.isPaginating) {
      return;
    }

    final nextPage = state.currentPage + 1;
    emit(state.copyWith(isPaginating: true));

    final result = await _getTransactionsUseCase.call(
      params: GetTransactionsParams(pageNumber: nextPage, pageSize: 20),
    );

    result.when(
      success: (newPagedResult) {
        final combinedItems = <TransactionModel>[
          ...currentResult.items,
          ...newPagedResult.items,
        ];

        final updatedResult = TransactionPagedResultModel(
          items: combinedItems,
          pageNumber: newPagedResult.pageNumber,
          pageSize: newPagedResult.pageSize,
          totalCount: newPagedResult.totalCount,
          totalPages: newPagedResult.totalPages,
          hasPreviousPage: newPagedResult.hasPreviousPage,
          hasNextPage: newPagedResult.hasNextPage,
        );

        emit(
          state.copyWith(
            transactionsResult: updatedResult,
            currentPage: nextPage,
            isPaginating: false,
          ),
        );
      },
      failure: (apiErrorModel) {
        emit(
          state.copyWith(
            isPaginating: false,
            apiErrorModel: apiErrorModel,
          ),
        );
      },
    );
  }
}
