import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/teacher/dashboard/data/models/pending_reviews_models.dart";
import "package:draya_mobile/features/teacher/dashboard/data/models/teacher_dashboard_model.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "teacher_dashboard_state.freezed.dart";

@freezed
abstract class TeacherDashboardState with _$TeacherDashboardState {
  const factory TeacherDashboardState({
    @Default(CubitStatus.initial) CubitStatus status,
    @Default(CubitStatus.initial) CubitStatus pendingReviewsStatus,
    TeacherDashboardModel? teacherDashboardModel,
    @Default([]) List<ClassroomPendingReviewsModel> pendingReviews,
    ApiErrorModel? apiErrorModel,
  }) = _TeacherDashboardState;
}
