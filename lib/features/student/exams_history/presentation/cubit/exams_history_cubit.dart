import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/student/exams_history/domain/entity/student_exam_history.dart";
import "package:draya_mobile/features/student/exams_history/domain/usecases/get_student_exams_history_params.dart";
import "package:draya_mobile/features/student/exams_history/domain/usecases/get_student_exams_history_use_case.dart";
import "package:draya_mobile/features/student/exams_history/presentation/cubit/exams_history_state.dart";
import "package:draya_mobile/features/student/student_enrolled_classrooms/data/models/student_enrolled_classroom_model.dart";
import "package:draya_mobile/features/student/student_enrolled_classrooms/domain/entity/student_enrolled_classroom.dart";
import "package:draya_mobile/features/student/student_enrolled_classrooms/domain/usecases/get_student_enrolled_classrooms_use_case.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ExamsHistoryCubit extends Cubit<ExamsHistoryState> {
  static const int _pageSize = 20;

  final GetStudentExamsHistoryUseCase _getStudentExamsHistoryUseCase;
  final GetStudentEnrolledClassroomsUseCase
      _getStudentEnrolledClassroomsUseCase;

  ExamsHistoryCubit(
    this._getStudentExamsHistoryUseCase,
    this._getStudentEnrolledClassroomsUseCase,
  ) : super(const ExamsHistoryState());

  Map<String, String> _classroomNames = {};

  void selectClassroom(String? classroomId) {
    emit(state.copyWith(selectedClassroomId: classroomId));
  }

  Future<void> getExamsHistory() async {
    emit(
      state.copyWith(
        status: CubitStatus.loading,
        exams: [],
        currentPage: 1,
        hasReachedMax: false,
        isLoadingMore: false,
        apiErrorModel: null,
      ),
    );

    await _loadClassroomNames();

    final result = await _getStudentExamsHistoryUseCase(
      params: const GetStudentExamsHistoryParams(page: 1, pageSize: _pageSize),
    );

    result.when(
      success: (page) => emit(
        state.copyWith(
          status: CubitStatus.success,
          exams: page.items.map(_withClassroomName).toList(),
          totalCount: page.totalCount,
          currentPage: 1,
          hasReachedMax:
              page.items.isEmpty || page.items.length >= page.totalCount,
        ),
      ),
      failure: (error) => emit(
        state.copyWith(status: CubitStatus.error, apiErrorModel: error),
      ),
    );
  }

  Future<void> _loadClassroomNames() async {
    final classrooms = await _fetchAllClassrooms();
    _classroomNames = {for (final c in classrooms) c.classroomId: c.name};
    emit(state.copyWith(classrooms: classrooms));
  }

  Future<List<StudentEnrolledClassroom>> _fetchAllClassrooms() async {
    const pageSize = 50;
    final classrooms = <StudentEnrolledClassroom>[];
    var page = 1;

    while (true) {
      final result = await _getStudentEnrolledClassroomsUseCase(
        params: StudentEnrolledClassroomsParams(
          page: page,
          pageSize: pageSize,
        ),
      );

      var reachedEnd = true;
      result.whenOrNull(
        success: (paged) {
          classrooms.addAll(paged.items.map((item) => item.toEntity()));
          reachedEnd =
              paged.items.isEmpty || paged.page >= paged.totalPages;
        },
      );

      if (reachedEnd) break;
      page++;
    }

    return classrooms;
  }

  StudentExamWithAttempts _withClassroomName(StudentExamWithAttempts exam) {
    final resolvedName = _classroomNames[exam.classroomId];
    return StudentExamWithAttempts(
      id: exam.id,
      title: exam.title,
      classroomId: exam.classroomId,
      classroomName:
          resolvedName ?? ((exam.classroomId?.isNotEmpty ?? false)
              ? "فصل دراسي"
              : null),
      latestScore: exam.latestScore,
      usedAttempts: exam.usedAttempts,
      allowedAttempts: exam.allowedAttempts,
      hasSubmitted: exam.hasSubmitted,
      attemptStatus: exam.attemptStatus,
      attempts: exam.attempts,
    );
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore ||
        state.hasReachedMax ||
        state.status != CubitStatus.success) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.currentPage + 1;

    final result = await _getStudentExamsHistoryUseCase(
      params: GetStudentExamsHistoryParams(
        page: nextPage,
        pageSize: _pageSize,
      ),
    );

    result.when(
      success: (page) {
        final updatedExams = [
          ...state.exams,
          ...page.items.map(_withClassroomName),
        ];
        emit(
          state.copyWith(
            isLoadingMore: false,
            exams: updatedExams,
            totalCount: page.totalCount,
            currentPage: nextPage,
            hasReachedMax:
                page.items.isEmpty || updatedExams.length >= page.totalCount,
          ),
        );
      },
      failure: (error) => emit(
        state.copyWith(isLoadingMore: false, apiErrorModel: error),
      ),
    );
  }
}
