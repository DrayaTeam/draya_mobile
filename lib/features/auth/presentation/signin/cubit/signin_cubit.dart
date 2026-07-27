import 'package:draya_mobile/core/enums/user_role.dart';
import 'package:draya_mobile/features/auth/presentation/signin/cubit/signin_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit() : super(SigninInitial());

  void navigateToSignUp({required UserRole userRole}) {
    emit(NavigateToSignup(userRole: userRole));
  }
}
