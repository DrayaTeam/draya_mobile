import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/teachers/domain/usecases/get_teacher_classrooms_use_case.dart";
import "package:draya_mobile/features/student/teachers/presentation/cubit/teacher_classrooms_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class TeacherClassroomsCubit extends Cubit<TeacherClassroomsState> {
  final GetTeacherClassroomsUseCase _getTeacherClassroomsUseCase;

  TeacherClassroomsCubit(this._getTeacherClassroomsUseCase)
    : super(const TeacherClassroomsState());

  Future<void> getTeacherClassrooms(
    String teacherId, {
    int page = 1,
    int pageSize = 20,
  }) async {
    if (teacherId.trim().isEmpty) {
      emit(
        state.copyWith(
          status: CubitStatus.error,
          apiErrorModel: null,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: CubitStatus.loading,
        apiErrorModel: null,
        teacherId: teacherId,
        page: page,
        pageSize: pageSize,
      ),
    );

    final result = await _getTeacherClassroomsUseCase.call(
      params: TeacherClassroomsParams(
        teacherId: teacherId,
        page: page,
        pageSize: pageSize,
      ),
    );

    result.when(
      success: (pagedResult) {
        emit(
          state.copyWith(
            status: CubitStatus.success,
            classrooms: pagedResult.items,
            page: pagedResult.page,
            pageSize: pagedResult.pageSize,
            totalCount: pagedResult.totalCount,
            totalPages: pagedResult.totalPages,
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
