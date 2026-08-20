import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/wallet/domain/usecases/get_teacher_balance_use_case.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/wallet_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class WalletCubit extends Cubit<WalletState> {
  final GetTeacherBalanceUseCase _getTeacherBalanceUseCase;

  WalletCubit(this._getTeacherBalanceUseCase) : super(const WalletState());

  Future<void> getTeacherBalance() async {
    emit(state.copyWith(status: CubitStatus.loading));

    final result = await _getTeacherBalanceUseCase.call();

    result.when(
      success: (balanceModel) {
        emit(
          state.copyWith(
            status: CubitStatus.success,
            teacherBalance: balanceModel,
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
