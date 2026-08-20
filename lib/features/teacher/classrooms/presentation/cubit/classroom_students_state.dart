import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/student_roster_item_model.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "classroom_students_state.freezed.dart";

@freezed
abstract class ClassroomStudentsState with _$ClassroomStudentsState {
  const factory ClassroomStudentsState({
    @Default(CubitStatus.initial) CubitStatus status,
    @Default([]) List<StudentRosterItemModel> students,
    ApiErrorModel? apiErrorModel,
  }) = _ClassroomStudentsState;
}
