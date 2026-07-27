import 'package:draya_mobile/features/auth/presentation/student_signup/cubit/student_signup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentSignupCubit extends Cubit<StudentSignupState> {
  StudentSignupCubit() : super(const StudentSignupState.initial());

  void navigateToMainScreen() {
    emit(const StudentSignupState.success());
  }

  void navigateToSignin() {
    emit(const StudentSignupState.navigateToSignin());
    emit(const StudentSignupState.initial());
  }
}
