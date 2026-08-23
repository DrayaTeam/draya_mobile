import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/classrooms/domain/usecases/delete_classroom_student_use_case.dart";
import "package:draya_mobile/features/teacher/classrooms/domain/usecases/get_classroom_students_use_case.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_students_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ClassroomStudentsCubit extends Cubit<ClassroomStudentsState> {
  final GetClassroomStudentsUseCase _getClassroomStudentsUseCase;
  final DeleteClassroomStudentUseCase _deleteClassroomStudentUseCase;

  ClassroomStudentsCubit(
    this._getClassroomStudentsUseCase,
    this._deleteClassroomStudentUseCase,
  ) : super(const ClassroomStudentsState());

  Future<void> getStudents(String classroomId) async {
    emit(
      state.copyWith(
        getStudentsStatus: CubitStatus.loading,
        deleteStudentStatus: CubitStatus.initial,
        apiErrorModel: null,
        students: [],
      ),
    );

    final result = await _getClassroomStudentsUseCase(params: classroomId);

    result.when(
      success: (page) => emit(
        state.copyWith(
          getStudentsStatus: CubitStatus.success,
          deleteStudentStatus: CubitStatus.initial,
          students: page.items,
        ),
      ),
      failure: (error) => emit(
        state.copyWith(
          getStudentsStatus: CubitStatus.error,
          deleteStudentStatus: CubitStatus.initial,
          apiErrorModel: error,
        ),
      ),
    );
  }

  Future<void> deleteClassroomStudent({
    required DeleteClassroomStudentUseCaseParams
    deleteClassroomStudentUseCaseParams,
  }) async {
    emit(
      state.copyWith(
        deleteStudentStatus: CubitStatus.loading,
        getStudentsStatus: CubitStatus.initial,
      ),
    );

    final result = await _deleteClassroomStudentUseCase(
      params: deleteClassroomStudentUseCaseParams,
    );

    result.when(
      success: (nothing) {
        emit(
          state.copyWith(
            deleteStudentStatus: CubitStatus.success,
            getStudentsStatus: CubitStatus.initial,
          ),
        );
      },
      failure: (apiErrorModel) {
        emit(
          state.copyWith(
            deleteStudentStatus: CubitStatus.error,
            getStudentsStatus: CubitStatus.initial,
          ),
        );
      },
    );
  }
}
