import "package:draya_mobile/features/home/presentation/home_screen/cubit/home_screen_state.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class HomeScreenCubit extends Cubit<HomeScreenState> {
  HomeScreenCubit() : super(HomeScreenInitial());

  void navigateToStudentSignin() {
    emit(NavigateToStudentSignin());
  }

  void navigateToTeacherSignin() {
    emit(NavigateToTeacherSignin());
  }
}
