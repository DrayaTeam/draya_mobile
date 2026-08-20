import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/teachers/domain/usecases/get_teachers_use_case.dart";
import "package:draya_mobile/features/student/teachers/presentation/cubit/teacher_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class TeacherCubit extends Cubit<TeacherState> {
  final GetTeachersUseCase _getTeachersUseCase;

  TeacherCubit(this._getTeachersUseCase) : super(const TeacherState());

  Future<void> getTeachers() async {
    emit(state.copyWith(status: CubitStatus.loading, apiErrorModel: null));

    final result = await _getTeachersUseCase.call();

    result.when(
      success: (teachers) {
        emit(
          state.copyWith(
            status: CubitStatus.success,
            teachers: teachers,
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
