import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/payout_account_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/payout_account_request_model.dart";
import "package:draya_mobile/features/teacher/wallet/domain/usecases/create_payout_account_use_case.dart";
import "package:draya_mobile/features/teacher/wallet/domain/usecases/delete_payout_account_use_case.dart";
import "package:draya_mobile/features/teacher/wallet/domain/usecases/get_payout_accounts_use_case.dart";
import "package:draya_mobile/features/teacher/wallet/domain/usecases/update_payout_account_use_case.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/payout_accounts_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class PayoutAccountsCubit extends Cubit<PayoutAccountsState> {
  final GetPayoutAccountsUseCase _getPayoutAccountsUseCase;
  final CreatePayoutAccountUseCase _createPayoutAccountUseCase;
  final UpdatePayoutAccountUseCase _updatePayoutAccountUseCase;
  final DeletePayoutAccountUseCase _deletePayoutAccountUseCase;

  PayoutAccountsCubit(
    this._getPayoutAccountsUseCase,
    this._createPayoutAccountUseCase,
    this._updatePayoutAccountUseCase,
    this._deletePayoutAccountUseCase,
  ) : super(const PayoutAccountsState());

  Future<void> getPayoutAccounts() async {
    emit(state.copyWith(status: CubitStatus.loading, actionSuccessMessage: null));

    final result = await _getPayoutAccountsUseCase.call();

    result.when(
      success: (accounts) {
        emit(
          state.copyWith(
            status: CubitStatus.success,
            accounts: accounts,
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

  Future<bool> createPayoutAccount(PayoutAccountRequestModel requestModel) async {
    emit(state.copyWith(isActionLoading: true, actionSuccessMessage: null));

    final result = await _createPayoutAccountUseCase.call(params: requestModel);

    return result.when(
      success: (newAccount) {
        final updatedList = List<PayoutAccountModel>.from(state.accounts);
        if (newAccount.isDefault) {
          // Unset default from others
          for (var i = 0; i < updatedList.length; i++) {
            if (updatedList[i].isDefault) {
              updatedList[i] = PayoutAccountModel(
                id: updatedList[i].id,
                teacherId: updatedList[i].teacherId,
                accountType: updatedList[i].accountType,
                accountName: updatedList[i].accountName,
                accountIdentifier: updatedList[i].accountIdentifier,
                isDefault: false,
                createdAt: updatedList[i].createdAt,
              );
            }
          }
        }
        updatedList.insert(0, newAccount);
        emit(
          state.copyWith(
            isActionLoading: false,
            accounts: updatedList,
            actionSuccessMessage: "تم إضافة حساب السحب بنجاح",
          ),
        );
        return true;
      },
      failure: (apiErrorModel) {
        emit(
          state.copyWith(
            isActionLoading: false,
            apiErrorModel: apiErrorModel,
          ),
        );
        return false;
      },
    );
  }

  Future<bool> updatePayoutAccount(
    String id,
    PayoutAccountRequestModel requestModel,
  ) async {
    emit(state.copyWith(isActionLoading: true, actionSuccessMessage: null));

    final result = await _updatePayoutAccountUseCase.call(
      params: UpdatePayoutAccountParams(id: id, requestModel: requestModel),
    );

    return result.when(
      success: (updatedAccount) {
        final updatedList = state.accounts.map<PayoutAccountModel>((acc) {
          if (acc.id == id) {
            return updatedAccount;
          }
          if (updatedAccount.isDefault && acc.isDefault) {
            return PayoutAccountModel(
              id: acc.id,
              teacherId: acc.teacherId,
              accountType: acc.accountType,
              accountName: acc.accountName,
              accountIdentifier: acc.accountIdentifier,
              isDefault: false,
              createdAt: acc.createdAt,
            );
          }
          return acc;
        }).toList();

        emit(
          state.copyWith(
            isActionLoading: false,
            accounts: updatedList,
            actionSuccessMessage: "تم تحديث بيانات الحساب بنجاح",
          ),
        );
        return true;
      },
      failure: (apiErrorModel) {
        emit(
          state.copyWith(
            isActionLoading: false,
            apiErrorModel: apiErrorModel,
          ),
        );
        return false;
      },
    );
  }

  Future<bool> deletePayoutAccount(String id) async {
    emit(state.copyWith(isActionLoading: true, actionSuccessMessage: null));

    final result = await _deletePayoutAccountUseCase.call(params: id);

    return result.when(
      success: (_) {
        final updatedList = state.accounts.where((acc) => acc.id != id).toList();
        emit(
          state.copyWith(
            isActionLoading: false,
            accounts: updatedList,
            actionSuccessMessage: "تم حذف حساب السحب بنجاح",
          ),
        );
        return true;
      },
      failure: (apiErrorModel) {
        emit(
          state.copyWith(
            isActionLoading: false,
            apiErrorModel: apiErrorModel,
          ),
        );
        return false;
      },
    );
  }
}
