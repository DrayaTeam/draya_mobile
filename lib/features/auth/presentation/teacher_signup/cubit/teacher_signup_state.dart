sealed class TeacherSignupState {}

class TeacherSignupInitial extends TeacherSignupState {}

class TeacherSignupLoading extends TeacherSignupState {}

class TeacherSignupSuccess extends TeacherSignupState {}

class TeacherSignupFailure extends TeacherSignupState {
  final String message;

  TeacherSignupFailure({required this.message});
}

class NavigateToSignin extends TeacherSignupState {}
