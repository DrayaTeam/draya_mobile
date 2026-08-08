import 'package:draya_mobile/core/enums/cubit_status.dart';
import 'package:draya_mobile/core/networking/api_error_model.dart';
import 'package:draya_mobile/features/teacher/subjects/data/models/subject_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subject_state.freezed.dart';

@freezed
abstract class SubjectState with _$SubjectState {
  const factory SubjectState({
    @Default(CubitStatus.initial) CubitStatus status,

    @Default([]) List<SubjectModel> subjects,

    ApiErrorModel? apiErrorModel,
  }) = _SubjectState;
}
