import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/student/teachers/data/models/classroom_checkout_response_model.dart";

class StudentCheckoutState {
  final CubitStatus status;
  final ClassroomCheckoutResponseModel? checkoutResponse;
  final ApiErrorModel? apiErrorModel;

  const StudentCheckoutState({
    this.status = CubitStatus.initial,
    this.checkoutResponse,
    this.apiErrorModel,
  });

  StudentCheckoutState copyWith({
    CubitStatus? status,
    ClassroomCheckoutResponseModel? checkoutResponse,
    ApiErrorModel? apiErrorModel,
  }) {
    return StudentCheckoutState(
      status: status ?? this.status,
      checkoutResponse: checkoutResponse ?? this.checkoutResponse,
      apiErrorModel: apiErrorModel ?? this.apiErrorModel,
    );
  }
}
