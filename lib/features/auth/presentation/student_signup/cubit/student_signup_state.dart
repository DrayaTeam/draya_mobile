sealed class StudentSignupState {}

class StudentSignupInitial extends StudentSignupState {}

class StudentSignupLoading extends StudentSignupState {}

class StudentSignupSuccess extends StudentSignupState {}

class StudentSignupFailure extends StudentSignupState {
  final String message;

  StudentSignupFailure({required this.message});
}

class NavigateToSignin extends StudentSignupState {}
