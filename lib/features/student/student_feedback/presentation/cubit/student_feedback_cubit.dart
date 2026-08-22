import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/student_enrolled_classrooms/data/models/student_enrolled_classroom_model.dart";
import "package:draya_mobile/features/student/student_enrolled_classrooms/domain/usecases/get_student_enrolled_classrooms_use_case.dart";
import "package:draya_mobile/features/student/student_feedback/domain/usecases/submit_feedback_use_case.dart";
import "package:draya_mobile/features/student/student_feedback/presentation/cubit/student_feedback_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class StudentFeedbackCubit extends Cubit<StudentFeedbackState> {
  final GetStudentEnrolledClassroomsUseCase _getStudentEnrolledClassroomsUseCase;
  final SubmitFeedbackUseCase _submitFeedbackUseCase;

  StudentFeedbackCubit(
    this._getStudentEnrolledClassroomsUseCase,
    this._submitFeedbackUseCase,
  ) : super(const StudentFeedbackState());

  static const int _pageSize = 50;

  Future<void> loadEligibleClassrooms() async {
    emit(
      const StudentFeedbackState().copyWith(
        status: CubitStatus.loading,
        apiErrorModel: null,
      ),
    );

    final result = await _getStudentEnrolledClassroomsUseCase.call(
      params: const StudentEnrolledClassroomsParams(
        page: 1,
        pageSize: _pageSize,
      ),
    );

    result.when(
      success: (pagedResult) {
        emit(
          state.copyWith(
            status: CubitStatus.success,
            classrooms: pagedResult.items
                .map((item) => item.toEntity())
                .toList(),
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

  Future<bool> submitFeedback({
    required String classroomId,
    required int rating,
    required String comment,
  }) async {
    if (rating < 1 || rating > 5) return false;

    emit(
      state.copyWith(
        submittingClassroomId: classroomId,
        apiErrorModel: null,
      ),
    );

    final result = await _submitFeedbackUseCase.call(
      params: SubmitFeedbackParams(
        classroomId: classroomId,
        rating: rating,
        comment: comment,
      ),
    );

    bool success = false;

    result.when(
      success: (_) {
        success = true;
        emit(
          state.copyWith(
            submittedClassroomIds: [
              ...state.submittedClassroomIds,
              classroomId,
            ],
            clearSubmittingClassroomId: true,
            apiErrorModel: null,
          ),
        );
      },
      failure: (apiErrorModel) {
        emit(
          state.copyWith(
            status: CubitStatus.error,
            clearSubmittingClassroomId: true,
            apiErrorModel: apiErrorModel,
          ),
        );
      },
    );

    return success;
  }
}
