import 'package:freezed_annotation/freezed_annotation.dart';

part "student_signup_state.freezed.dart";

@freezed
sealed class StudentSignupState with _$StudentSignupState {
  const factory StudentSignupState.initial() = StudentSignupInitial;

  const factory StudentSignupState.loading() = StudentSignupLoading;

  const factory StudentSignupState.success() = StudentSignupSuccess;

  const factory StudentSignupState.failure({required String message}) =
      StudentSignupFailure;

  const factory StudentSignupState.navigateToSignin() = NavigateToSignin;
}
