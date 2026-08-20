import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/classrooms/domain/usecases/get_classroom_students_use_case.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_students_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ClassroomStudentsCubit extends Cubit<ClassroomStudentsState> {
  final GetClassroomStudentsUseCase _getClassroomStudentsUseCase;

  ClassroomStudentsCubit(this._getClassroomStudentsUseCase)
    : super(const ClassroomStudentsState());

  Future<void> getStudents(String classroomId) async {
    emit(state.copyWith(status: CubitStatus.loading, apiErrorModel: null));
    final result = await _getClassroomStudentsUseCase(params: classroomId);
    result.when(
      success: (page) => emit(
        state.copyWith(status: CubitStatus.success, students: page.items),
      ),
      failure: (error) => emit(
        state.copyWith(status: CubitStatus.error, apiErrorModel: error),
      ),
    );
  }
}
