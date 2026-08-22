import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/teacher/teacher_feedback/domain/entity/classroom_feedback.dart";

class ClassroomFeedbackState {
  final CubitStatus status;
  final List<ClassroomFeedback> items;
  final double averageRating;
  final int totalCount;
  final int page;
  final bool hasNextPage;
  final bool isLoadingMore;
  final ApiErrorModel? apiErrorModel;

  const ClassroomFeedbackState({
    this.status = CubitStatus.initial,
    this.items = const [],
    this.averageRating = 0,
    this.totalCount = 0,
    this.page = 1,
    this.hasNextPage = false,
    this.isLoadingMore = false,
    this.apiErrorModel,
  });

  ClassroomFeedbackState copyWith({
    CubitStatus? status,
    List<ClassroomFeedback>? items,
    double? averageRating,
    int? totalCount,
    int? page,
    bool? hasNextPage,
    bool? isLoadingMore,
    ApiErrorModel? apiErrorModel,
  }) {
    return ClassroomFeedbackState(
      status: status ?? this.status,
      items: items ?? this.items,
      averageRating: averageRating ?? this.averageRating,
      totalCount: totalCount ?? this.totalCount,
      page: page ?? this.page,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      apiErrorModel: apiErrorModel ?? this.apiErrorModel,
    );
  }
}
