import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/top_up_request_model.dart";
import "package:draya_mobile/features/teacher/wallet/domain/usecases/top_up_use_case.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/top_up_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class TopUpCubit extends Cubit<TopUpState> {
  final TopUpUseCase _topUpUseCase;

  TopUpCubit(this._topUpUseCase) : super(const TopUpState());

  Future<void> topUp({required TopUpRequestModel topUpRequestModel}) async {
    emit(state.copyWith(status: CubitStatus.loading));

    final result = await _topUpUseCase.call(params: topUpRequestModel);

    result.when(
      success: (topUpResponseModel) {
        emit(
          state.copyWith(
            status: CubitStatus.success,
            topUpResponseModel: topUpResponseModel,
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
