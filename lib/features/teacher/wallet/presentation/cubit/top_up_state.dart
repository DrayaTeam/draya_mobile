import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/teacher/wallet/data/models/top_up_response_model.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "top_up_state.freezed.dart";

@freezed
abstract class TopUpState with _$TopUpState {
  const factory TopUpState({
    @Default(CubitStatus.initial) CubitStatus status,
    TopUpResponseModel? topUpResponseModel,
    ApiErrorModel? apiErrorModel,
  }) = _TopUpState;
}
