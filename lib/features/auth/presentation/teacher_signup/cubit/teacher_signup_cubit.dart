import 'package:draya_mobile/features/auth/presentation/teacher_signup/cubit/teacher_signup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherSignupCubit extends Cubit<TeacherSignupState> {
  TeacherSignupCubit() : super(TeacherSignupInitial());

  void navigateToMainScreen() {
    emit(TeacherSignupSuccess());
  }

  void navigateToSignin() {
    emit(NavigateToSignin());
  }
}
