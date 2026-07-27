import 'package:draya_mobile/core/enums/user_role.dart';

sealed class SigninState {}

class SigninInitial extends SigninState {}

class SigninLoading extends SigninState {}

class SigninSuccess extends SigninState {}

class SigninFailure extends SigninState {
  final String message;

  SigninFailure({required this.message});
}

class NavigateToSignup extends SigninState {
  final UserRole userRole;

  NavigateToSignup({required this.userRole});
}
