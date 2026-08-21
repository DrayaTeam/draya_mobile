import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/student/home/domain/entity/student_dashboard.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "student_home_state.freezed.dart";

@freezed
abstract class StudentHomeState with _$StudentHomeState {
  const factory StudentHomeState({
    @Default(CubitStatus.initial) CubitStatus status,
    StudentDashboard? studentDashboard,
    ApiErrorModel? apiErrorModel,
  }) = _StudentHomeState;
}
