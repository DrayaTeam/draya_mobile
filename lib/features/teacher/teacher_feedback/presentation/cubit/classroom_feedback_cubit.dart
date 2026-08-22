import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_result.dart";
import "package:draya_mobile/features/teacher/teacher_feedback/data/models/feedback_item_model.dart";
import "package:draya_mobile/features/teacher/teacher_feedback/domain/usecases/get_classroom_feedback_use_case.dart";
import "package:draya_mobile/features/teacher/teacher_feedback/presentation/cubit/classroom_feedback_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ClassroomFeedbackCubit extends Cubit<ClassroomFeedbackState> {
  final GetClassroomFeedbackUseCase _getClassroomFeedbackUseCase;

  ClassroomFeedbackCubit(this._getClassroomFeedbackUseCase)
      : super(const ClassroomFeedbackState());

  String _classroomId = "";

  Future<void> loadFeedback(String classroomId) async {
    _classroomId = classroomId;

    emit(
      state.copyWith(
        status: CubitStatus.loading,
        apiErrorModel: null,
      ),
    );

    await _fetch(page: 1, append: false);
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasNextPage) return;

    emit(state.copyWith(isLoadingMore: true));

    await _fetch(page: state.page + 1, append: true);
  }

  Future<void> refresh() => loadFeedback(_classroomId);

  Future<void> _fetch({required int page, required bool append}) async {
    final result = await _getClassroomFeedbackUseCase.call(
      params: ClassroomFeedbackParams(
        classroomId: _classroomId,
        page: page,
      ),
    );

    result.when(
      success: (pagedResult) {
        final newItems =
            pagedResult.items.map((item) => item.toEntity()).toList();

        emit(
          state.copyWith(
            status: CubitStatus.success,
            items: append ? [...state.items, ...newItems] : newItems,
            averageRating: pagedResult.averageRating,
            totalCount: pagedResult.totalCount,
            page: pagedResult.pageNumber,
            hasNextPage: pagedResult.hasNextPage,
            isLoadingMore: false,
            apiErrorModel: null,
          ),
        );
      },
      failure: (apiErrorModel) {
        if (append) {
          emit(state.copyWith(isLoadingMore: false));
        } else {
          emit(
            state.copyWith(
              status: CubitStatus.error,
              apiErrorModel: apiErrorModel,
            ),
          );
        }
      },
    );
  }
}
