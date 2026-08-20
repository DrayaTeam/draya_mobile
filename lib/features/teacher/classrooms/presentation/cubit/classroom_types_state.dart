import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/teacher/classrooms/data/models/classroom_type_model.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "classroom_types_state.freezed.dart";

@freezed
abstract class ClassroomTypesState with _$ClassroomTypesState {
  const factory ClassroomTypesState({
    @Default(CubitStatus.initial) CubitStatus status,
    @Default([]) List<ClassroomTypeModel> classroomTypes,
    ApiErrorModel? apiErrorModel,
  }) = _ClassroomTypesState;
}
