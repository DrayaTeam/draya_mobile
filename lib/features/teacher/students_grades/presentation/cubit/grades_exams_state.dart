import "package:draya_mobile/core/enums/cubit_status.dart";
import "package:draya_mobile/core/networking/api_error_model.dart";
import "package:draya_mobile/features/teacher/sections/data/models/section_exam_model.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "grades_exams_state.freezed.dart";

@freezed
abstract class ExamGradesItem with _$ExamGradesItem {
  const factory ExamGradesItem({
    required SectionExamModel exam,
    required String sectionTitle,
  }) = _ExamGradesItem;
}

@freezed
abstract class GradesExamsState with _$GradesExamsState {
  const factory GradesExamsState({
    @Default(CubitStatus.initial) CubitStatus status,
    @Default([]) List<ExamGradesItem> exams,
    ApiErrorModel? apiErrorModel,
  }) = _GradesExamsState;
}
