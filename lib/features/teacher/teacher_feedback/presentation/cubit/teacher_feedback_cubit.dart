import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/classroom_model.dart";
import "package:draya_mobile/features/teacher/classrooms/domain/usecases/get_classrooms_use_case.dart";
import "package:draya_mobile/features/teacher/teacher_feedback/presentation/cubit/teacher_feedback_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class TeacherFeedbackCubit extends Cubit<TeacherFeedbackState> {
  final GetClassroomsUseCase _getClassroomsUseCase;

  TeacherFeedbackCubit(this._getClassroomsUseCase)
      : super(const TeacherFeedbackState());

  Future<void> loadTeacherClassrooms() async {
    emit(state.copyWith(status: CubitStatus.loading, apiErrorModel: null));

    final result = await _getClassroomsUseCase.call();

    result.when(
      success: (pagedResult) {
        emit(
          state.copyWith(
            status: CubitStatus.success,
            classrooms:
                pagedResult.items.map((item) => item.toEntity()).toList(),
            apiErrorModel: null,
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
