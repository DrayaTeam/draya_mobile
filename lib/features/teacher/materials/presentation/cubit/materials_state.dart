import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/teacher/materials/data/models/teacher_material_paged_result_model.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "materials_state.freezed.dart";

@freezed
abstract class MaterialsState with _$MaterialsState {
  const factory MaterialsState({
    @Default(CubitStatus.initial) CubitStatus getMaterialsStatus,
    @Default(CubitStatus.initial) CubitStatus uploadMaterialsStatus,
    TeacherMaterialPagedResultModel? teacherMaterialPagedResultModel,
    ApiErrorModel? apiErrorModel,
  }) = _MaterialsState;
}
