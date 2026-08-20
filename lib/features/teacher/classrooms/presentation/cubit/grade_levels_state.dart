import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/grade_level_model.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "grade_levels_state.freezed.dart";

@freezed
abstract class GradeLevelsState with _$GradeLevelsState {
  const factory GradeLevelsState({
    @Default(CubitStatus.initial) CubitStatus status,
    @Default([]) List<GradeLevelModel> gradeLevels,
    ApiErrorModel? apiErrorModel,
  }) = _GradeLevelsState;
}
