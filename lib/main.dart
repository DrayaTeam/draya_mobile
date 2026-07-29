import 'package:draya_mobile/features/auth/presentation/signin/cubit/signin_cubit.dart';
import 'package:draya_mobile/features/auth/presentation/student_signup/cubit/student_signup_cubit.dart';
import 'package:draya_mobile/features/auth/presentation/teacher_signup/cubit/teacher_signup_cubit.dart';
import 'package:draya_mobile/features/home/presentation/home_screen/cubit/home_screen_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'app/draya_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFFFAFAF8),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<HomeScreenCubit>(
          create: (_) => HomeScreenCubit(),
        ),
        BlocProvider<SigninCubit>(
          create: (_) => SigninCubit(),
        ),
        BlocProvider<StudentSignupCubit>(
          create: (_) => StudentSignupCubit(),
        ),
        BlocProvider<TeacherSignupCubit>(
          create: (_) => TeacherSignupCubit(),
        ),
      ],
      child: const DrayaApp(),
    ),
  );
}
