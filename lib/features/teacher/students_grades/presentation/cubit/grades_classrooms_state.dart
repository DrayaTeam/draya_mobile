import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/classroom_model.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "grades_classrooms_state.freezed.dart";

@freezed
abstract class GradesClassroomsState with _$GradesClassroomsState {
  const factory GradesClassroomsState({
    @Default(CubitStatus.initial) CubitStatus status,
    @Default([]) List<ClassroomModel> classrooms,
    ApiErrorModel? apiErrorModel,
  }) = _GradesClassroomsState;
}
