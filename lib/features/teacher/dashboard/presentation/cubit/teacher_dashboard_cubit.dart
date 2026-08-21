import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/dashboard/domain/usecases/get_teacher_dashboard_use_case.dart";
import "package:draya_mobile/features/teacher/dashboard/presentation/cubit/teacher_dashboard_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class TeacherDashboardCubit extends Cubit<TeacherDashboardState> {
  final GetTeacherDashboardUseCase _getTeacherDashboardUseCase;

  TeacherDashboardCubit(this._getTeacherDashboardUseCase)
    : super(const TeacherDashboardState());

  Future<void> getTeacherDashboard() async {
    emit(state.copyWith(status: CubitStatus.loading));

    final result = await _getTeacherDashboardUseCase.call();

    result.when(
      success: (teacherDashboardModel) {
        emit(
          state.copyWith(
            status: CubitStatus.success,
            teacherDashboardModel: teacherDashboardModel,
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
