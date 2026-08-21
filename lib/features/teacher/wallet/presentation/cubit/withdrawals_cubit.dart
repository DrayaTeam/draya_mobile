import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/withdrawal_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/withdrawal_paged_result_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/withdrawal_request_model.dart";
import "package:draya_mobile/features/teacher/wallet/domain/usecases/create_withdrawal_use_case.dart";
import "package:draya_mobile/features/teacher/wallet/domain/usecases/get_withdrawals_use_case.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/withdrawals_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class WithdrawalsCubit extends Cubit<WithdrawalsState> {
  final GetWithdrawalsUseCase _getWithdrawalsUseCase;
  final CreateWithdrawalUseCase _createWithdrawalUseCase;

  WithdrawalsCubit(
    this._getWithdrawalsUseCase,
    this._createWithdrawalUseCase,
  ) : super(const WithdrawalsState());

  Future<void> getWithdrawals({bool isRefresh = false}) async {
    if (isRefresh) {
      emit(
        state.copyWith(
          status: CubitStatus.loading,
          currentPage: 1,
          actionSuccessMessage: null,
        ),
      );
    } else {
      if (state.withdrawalsResult == null) {
        emit(state.copyWith(status: CubitStatus.loading));
      }
    }

    final result = await _getWithdrawalsUseCase.call(
      params: const GetWithdrawalsParams(pageNumber: 1, pageSize: 20),
    );

    result.when(
      success: (pagedResult) {
        emit(
          state.copyWith(
            status: CubitStatus.success,
            withdrawalsResult: pagedResult,
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

  Future<void> loadMoreWithdrawals() async {
    final currentResult = state.withdrawalsResult;
    if (currentResult == null ||
        !currentResult.hasNextPage ||
        state.isPaginating) {
      return;
    }

    final nextPage = state.currentPage + 1;
    emit(state.copyWith(isPaginating: true));

    final result = await _getWithdrawalsUseCase.call(
      params: GetWithdrawalsParams(pageNumber: nextPage, pageSize: 20),
    );

    result.when(
      success: (newPagedResult) {
        final combinedItems = <WithdrawalModel>[
          ...currentResult.items,
          ...newPagedResult.items,
        ];

        final updatedResult = WithdrawalPagedResultModel(
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
            withdrawalsResult: updatedResult,
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

  Future<bool> createWithdrawal(WithdrawalRequestModel requestModel) async {
    emit(
      state.copyWith(
        isSubmittingWithdrawal: true,
        actionSuccessMessage: null,
        submittedWithdrawal: null,
      ),
    );

    final result = await _createWithdrawalUseCase.call(params: requestModel);

    return result.when(
      success: (newWithdrawal) {
        final currentResult = state.withdrawalsResult;
        final updatedItems = <WithdrawalModel>[
          newWithdrawal,
          if (currentResult != null) ...currentResult.items,
        ];

        final updatedResult = WithdrawalPagedResultModel(
          items: updatedItems,
          pageNumber: currentResult?.pageNumber ?? 1,
          pageSize: currentResult?.pageSize ?? 20,
          totalCount: (currentResult?.totalCount ?? 0) + 1,
          totalPages: currentResult?.totalPages ?? 1,
          hasPreviousPage: currentResult?.hasPreviousPage ?? false,
          hasNextPage: currentResult?.hasNextPage ?? false,
        );

        emit(
          state.copyWith(
            isSubmittingWithdrawal: false,
            submittedWithdrawal: newWithdrawal,
            withdrawalsResult: updatedResult,
            actionSuccessMessage:
                "تم تقديم طلب السحب بنجاح! سيتم تحويل المبلغ بعد مراجعة وتأكيد الإدارة.",
          ),
        );
        return true;
      },
      failure: (apiErrorModel) {
        emit(
          state.copyWith(
            isSubmittingWithdrawal: false,
            apiErrorModel: apiErrorModel,
          ),
        );
        return false;
      },
    );
  }
}
