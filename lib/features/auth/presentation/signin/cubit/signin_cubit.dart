import 'package:draya_mobile/core/enums/user_role.dart';
import 'package:draya_mobile/features/auth/presentation/signin/cubit/signin_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit() : super(const SigninState.initial());

  void navigateToSignUp({required UserRole userRole}) {
    emit(SigninState.navigateToSignup(userRole: userRole));
    emit(const SigninState.initial());
  }
}
