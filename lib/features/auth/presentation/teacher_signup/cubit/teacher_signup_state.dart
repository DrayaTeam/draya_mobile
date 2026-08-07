import 'package:draya_mobile/core/networking/api_error_model.dart';
import 'package:draya_mobile/features/auth/domain/entity/auth_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part "teacher_signup_state.freezed.dart";

@freezed
sealed class TeacherSignupState with _$TeacherSignupState {
  const factory TeacherSignupState.initial() = TeacherSignupInitial;

  const factory TeacherSignupState.loading() = TeacherSignupLoading;

  const factory TeacherSignupState.success({required AuthEntity authEntity}) =
      TeacherSignupSuccess;

  const factory TeacherSignupState.failure({
    required ApiErrorModel apiErrorModel,
  }) = TeacherSignupFailure;
}
