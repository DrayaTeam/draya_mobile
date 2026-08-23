import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/classrooms/domain/usecases/get_classrooms_use_case.dart";
import "package:draya_mobile/features/teacher/students_grades/presentation/cubit/grades_classrooms_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class GradesClassroomsCubit extends Cubit<GradesClassroomsState> {
  final GetClassroomsUseCase _getClassroomsUseCase;

  GradesClassroomsCubit(this._getClassroomsUseCase)
      : super(const GradesClassroomsState());

  Future<void> getClassrooms() async {
    emit(state.copyWith(status: CubitStatus.loading, apiErrorModel: null));

    final result = await _getClassroomsUseCase();

    result.when(
      success: (page) => emit(
        state.copyWith(
          status: CubitStatus.success,
          classrooms: page.items,
          apiErrorModel: null,
        ),
      ),
      failure: (error) => emit(
        state.copyWith(status: CubitStatus.error, apiErrorModel: error),
      ),
    );
  }
}
