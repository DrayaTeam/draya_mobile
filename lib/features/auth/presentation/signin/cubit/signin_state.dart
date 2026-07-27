import 'package:draya_mobile/core/enums/user_role.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part "signin_state.freezed.dart";

@freezed
sealed class SigninState with _$SigninState {
  const factory SigninState.initial() = SigninInitial;

  const factory SigninState.loading() = SigninLoading;

  const factory SigninState.success() = SigninSuccess;

  const factory SigninState.failure({required String message}) = SigninFailure;

  const factory SigninState.navigateToSignup({required UserRole userRole}) =
      NavigateToSignup;
}
