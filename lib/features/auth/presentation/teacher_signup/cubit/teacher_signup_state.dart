import 'package:freezed_annotation/freezed_annotation.dart';

part "teacher_signup_state.freezed.dart";

@freezed
sealed class TeacherSignupState with _$TeacherSignupState {
  const factory TeacherSignupState.initial() = TeacherSignupInitial;

  const factory TeacherSignupState.loading() = TeacherSignupLoading;

  const factory TeacherSignupState.success() = TeacherSignupSuccess;

  const factory TeacherSignupState.failure({required String message}) =
      TeacherSignupFailure;
}
