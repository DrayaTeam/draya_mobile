import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/teachers/domain/usecases/checkout_classroom_use_case.dart";
import "package:draya_mobile/features/student/teachers/presentation/cubit/student_checkout_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class StudentCheckoutCubit extends Cubit<StudentCheckoutState> {
  final CheckoutClassroomUseCase _checkoutClassroomUseCase;

  StudentCheckoutCubit(this._checkoutClassroomUseCase)
    : super(const StudentCheckoutState());

  static const paymentResultRedirectUrl = "draya://payment-result";

  Future<void> checkoutClassroom(String classroomId) async {
    if (classroomId.trim().isEmpty) {
      emit(
        state.copyWith(
          status: CubitStatus.error,
          apiErrorModel: null,
        ),
      );
      return;
    }

    emit(state.copyWith(status: CubitStatus.loading, apiErrorModel: null));

    final result = await _checkoutClassroomUseCase.call(
      params: CheckoutClassroomParams(
        classroomId: classroomId,
        redirectionUrl: paymentResultRedirectUrl,
      ),
    );

    result.when(
      success: (response) {
        emit(
          state.copyWith(
            status: CubitStatus.success,
            checkoutResponse: response,
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
