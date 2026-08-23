import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/teacher/sections/data/models/section_model.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "materials_state.freezed.dart";

@freezed
abstract class MaterialsState with _$MaterialsState {
  const factory MaterialsState({
    @Default(CubitStatus.initial) CubitStatus getMaterialsStatus,
    @Default(CubitStatus.initial) CubitStatus uploadMaterialsStatus,
    @Default(CubitStatus.initial) CubitStatus deleteMaterialStatus,
    SectionModel? sectionModel,
    ApiErrorModel? apiErrorModel,
  }) = _MaterialsState;
}
