import 'package:draya_mobile/core/enums/cubit_status.dart';
import 'package:draya_mobile/core/networking/api_error_model.dart';
import 'package:draya_mobile/features/teacher/profile/data/models/teacher_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part "teacher_profile_state.freezed.dart";

@freezed
abstract class TeacherProfileState with _$TeacherProfileState {
  const factory TeacherProfileState({
    @Default(CubitStatus.initial) CubitStatus status,
    @Default(null) TeacherModel? teacher,
    @Default(false) bool isUploadingPicture,
    ApiErrorModel? apiErrorModel,
  }) = _TeacherProfileState;
}
