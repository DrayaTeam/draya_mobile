import 'package:draya_mobile/core/helpers/app_shared_pref_helper.dart';
import 'package:draya_mobile/core/localization/locale_cubit.dart';
import 'package:draya_mobile/features/auth/presentation/signin/cubit/signin_cubit.dart';
import 'package:draya_mobile/features/auth/presentation/student_signup/cubit/student_signup_cubit.dart';
import 'package:draya_mobile/features/auth/presentation/teacher_signup/cubit/teacher_signup_cubit.dart';
import 'package:draya_mobile/features/auth/presentation/signup_choice/cubit/signup_choice_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/draya_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSharedPrefHelper.init();
  await initializeDateFormatting("ar");
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
        BlocProvider<SignupChoiceCubit>(
          create: (_) => SignupChoiceCubit(),
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
        BlocProvider<LocaleCubit>(
          create: (context) => LocaleCubit(),
        ),
      ],
      child: const DrayaApp(),
    ),
  );
}
