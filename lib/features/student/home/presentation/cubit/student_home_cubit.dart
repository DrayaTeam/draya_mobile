import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/home/domain/usecases/get_student_dashboard_use_case.dart";
import "package:draya_mobile/features/student/home/presentation/cubit/student_home_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class StudentHomeCubit extends Cubit<StudentHomeState> {
  final GetStudentDashboardUseCase _getStudentDashboardUseCase;

  StudentHomeCubit(this._getStudentDashboardUseCase)
      : super(const StudentHomeState());

  Future<void> getStudentDashboard() async {
    emit(state.copyWith(status: CubitStatus.loading));

    final result = await _getStudentDashboardUseCase.call();

    result.when(
      success: (studentDashboard) {
        emit(
          state.copyWith(
            status: CubitStatus.success,
            studentDashboard: studentDashboard,
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
