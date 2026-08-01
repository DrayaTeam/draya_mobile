import "package:draya_mobile/features/auth/presentation/signup_choice/cubit/signup_choice_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class SignupChoiceCubit extends Cubit<SignupChoiceState> {
  SignupChoiceCubit() : super(SignupChoiceInitial());

  void navigateToStudentSignin() {
    emit(NavigateToStudentSignin());
  }

  void navigateToTeacherSignin() {
    emit(NavigateToTeacherSignin());
  }
}
