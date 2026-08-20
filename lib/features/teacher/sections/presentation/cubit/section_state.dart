import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/teacher/sections/data/models/section_model.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "section_state.freezed.dart";

@freezed
abstract class SectionState with _$SectionState {
  const factory SectionState({
    @Default(CubitStatus.initial) CubitStatus getSectionsStatus,
    @Default(CubitStatus.initial) CubitStatus createSectionStatus,
    @Default(CubitStatus.initial) CubitStatus deleteSectionStatus,
    @Default([]) List<SectionModel> sections,
    ApiErrorModel? apiErrorModel,
  }) = _SectionState;
}
