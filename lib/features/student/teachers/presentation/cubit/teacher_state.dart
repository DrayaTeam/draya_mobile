import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/student/teachers/data/models/teacher_model.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "teacher_state.freezed.dart";

@freezed
abstract class TeacherState with _$TeacherState {
  const factory TeacherState({
    @Default(CubitStatus.initial) CubitStatus status,
    @Default([]) List<TeacherModel> teachers,
    ApiErrorModel? apiErrorModel,
  }) = _TeacherState;
}
