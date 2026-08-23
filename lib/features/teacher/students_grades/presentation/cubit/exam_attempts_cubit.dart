import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/students_grades/domain/usecases/get_exam_attempts_use_case.dart";
import "package:draya_mobile/features/teacher/students_grades/presentation/cubit/exam_attempts_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ExamAttemptsCubit extends Cubit<ExamAttemptsState> {
  static const int _pageSize = 10;

  final GetExamAttemptsUseCase _getExamAttemptsUseCase;

  String? _examId;

  ExamAttemptsCubit(this._getExamAttemptsUseCase)
      : super(const ExamAttemptsState());

  Future<void> getAttempts(String examId) async {
    _examId = examId;

    emit(
      state.copyWith(
        status: CubitStatus.loading,
        attempts: [],
        currentPage: 1,
        hasReachedMax: false,
        isLoadingMore: false,
        apiErrorModel: null,
      ),
    );

    final result = await _getExamAttemptsUseCase(
      params: GetExamAttemptsParams(examId: examId, page: 1),
    );

    result.when(
      success: (page) => emit(
        state.copyWith(
          status: CubitStatus.success,
          attempts: page.items,
          totalCount: page.totalCount,
          currentPage: 1,
          hasReachedMax:
              page.items.isEmpty || page.items.length >= page.totalCount,
          apiErrorModel: null,
        ),
      ),
      failure: (error) => emit(
        state.copyWith(status: CubitStatus.error, apiErrorModel: error),
      ),
    );
  }

  Future<void> loadMore() async {
    final examId = _examId;
    if (examId == null ||
        state.isLoadingMore ||
        state.hasReachedMax ||
        state.status != CubitStatus.success) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.currentPage + 1;

    final result = await _getExamAttemptsUseCase(
      params: GetExamAttemptsParams(
        examId: examId,
        page: nextPage,
        pageSize: _pageSize,
      ),
    );

    result.when(
      success: (page) {
        final updatedAttempts = [...state.attempts, ...page.items];
        emit(
          state.copyWith(
            isLoadingMore: false,
            attempts: updatedAttempts,
            totalCount: page.totalCount,
            currentPage: nextPage,
            hasReachedMax:
                page.items.isEmpty ||
                    updatedAttempts.length >= page.totalCount,
          ),
        );
      },
      failure: (error) => emit(
        state.copyWith(isLoadingMore: false, apiErrorModel: error),
      ),
    );
  }
}
