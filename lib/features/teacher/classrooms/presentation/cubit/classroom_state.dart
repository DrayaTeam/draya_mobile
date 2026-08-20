import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/classroom_model.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "classroom_state.freezed.dart";

@freezed
abstract class ClassroomState with _$ClassroomState {
  const factory ClassroomState({
    @Default(CubitStatus.initial) CubitStatus status,
    @Default([]) List<ClassroomModel> classrooms,
    ApiErrorModel? apiErrorModel,
  }) = _ClassroomState;
}
