import "dart:async";

import "package:draya_mobile/core/di/dependency_injection.dart";
import "package:draya_mobile/core/helpers/app_shared_pref_helper.dart";
import "package:draya_mobile/core/helpers/app_token_helper.dart";
import "package:draya_mobile/core/localization/locale_cubit.dart";
import "package:draya_mobile/core/services/deep_link_service.dart";
import "package:draya_mobile/core/services/local_notification_service.dart";
import "package:draya_mobile/features/auth/domain/usecases/login_use_case.dart";
import "package:draya_mobile/features/auth/domain/usecases/student_register_use_case.dart";
import "package:draya_mobile/features/auth/domain/usecases/teacher_register_use_case.dart";
import "package:draya_mobile/features/auth/presentation/signin/cubit/signin_cubit.dart";
import "package:draya_mobile/features/auth/presentation/student_signup/cubit/student_signup_cubit.dart";
import "package:draya_mobile/features/auth/presentation/teacher_signup/cubit/teacher_signup_cubit.dart";
import "package:draya_mobile/features/auth/presentation/signup_choice/cubit/signup_choice_cubit.dart";
import "package:draya_mobile/features/student/home/domain/usecases/get_student_dashboard_use_case.dart";
import "package:draya_mobile/features/student/home/presentation/cubit/student_home_cubit.dart";
import "package:draya_mobile/features/student/profile/domain/usecases/get_student_profile_use_case.dart";
import "package:draya_mobile/features/student/profile/domain/usecases/update_student_profile_use_case.dart";
import "package:draya_mobile/features/student/profile/domain/usecases/upload_student_profile_picture_use_case.dart";
import "package:draya_mobile/features/student/profile/presentation/cubit/student_profile_cubit.dart";
import "package:draya_mobile/features/student/student_enrolled_classrooms/domain/usecases/enroll_classroom_use_case.dart";
import "package:draya_mobile/features/student/student_enrolled_classrooms/domain/usecases/get_student_enrolled_classrooms_use_case.dart";
import "package:draya_mobile/features/student/student_enrolled_classrooms/presentation/cubit/student_enrolled_classrooms_cubit.dart";
import "package:draya_mobile/features/student/student_feedback/domain/usecases/submit_feedback_use_case.dart";
import "package:draya_mobile/features/student/student_feedback/presentation/cubit/student_feedback_cubit.dart";
import "package:draya_mobile/features/student/student_materials/domain/usecases/get_classroom_sections_use_case.dart";
import "package:draya_mobile/features/student/student_materials/domain/usecases/get_enrolled_materials_use_case.dart";
import "package:draya_mobile/features/student/student_materials/domain/usecases/get_material_stream_use_case.dart";
import "package:draya_mobile/features/student/student_materials/presentation/cubit/student_materials_cubit.dart";
import "package:draya_mobile/features/student/teachers/domain/usecases/checkout_classroom_use_case.dart";
import "package:draya_mobile/features/student/teachers/domain/usecases/get_payment_status_use_case.dart";
import "package:draya_mobile/features/student/teachers/domain/usecases/get_teacher_classrooms_use_case.dart";
import "package:draya_mobile/features/student/teachers/domain/usecases/get_teachers_use_case.dart";
import "package:draya_mobile/features/student/teachers/presentation/cubit/payment_verification_cubit.dart";
import "package:draya_mobile/features/student/teachers/presentation/cubit/student_checkout_cubit.dart";
import "package:draya_mobile/features/student/teachers/presentation/cubit/teacher_classrooms_cubit.dart";
import "package:draya_mobile/features/student/teachers/presentation/cubit/teacher_cubit.dart";
import "package:draya_mobile/features/teacher/classrooms/domain/usecases/delete_classroom_student_use_case.dart";
import "package:draya_mobile/features/teacher/classrooms/domain/usecases/delete_classroom_use_case.dart";
import "package:draya_mobile/features/teacher/classrooms/domain/usecases/get_classroom_types_use_case.dart";
import "package:draya_mobile/features/teacher/classrooms/domain/usecases/get_grade_levels_use_case.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_types_cubit.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/grade_levels_cubit.dart";
import "package:draya_mobile/features/teacher/dashboard/domain/usecases/get_teacher_dashboard_use_case.dart";
import "package:draya_mobile/features/teacher/dashboard/presentation/cubit/teacher_dashboard_cubit.dart";
import "package:draya_mobile/features/teacher/materials/domain/usecases/delete_material_use_case.dart";
import "package:draya_mobile/features/teacher/materials/domain/usecases/get_materials_use_case.dart";
import "package:draya_mobile/features/teacher/materials/domain/usecases/upload_materials_use_case.dart";
import "package:draya_mobile/features/teacher/materials/presentation/cubit/materials_cubit.dart";
import "package:draya_mobile/features/teacher/profile/domain/usecases/get_teacher_profile_use_case.dart";
import "package:draya_mobile/features/teacher/profile/domain/usecases/update_teacher_profile_use_case.dart";
import "package:draya_mobile/features/teacher/profile/domain/usecases/upload_teacher_profile_picture_use_case.dart";
import "package:draya_mobile/features/teacher/profile/presentation/cubit/teacher_profile_cubit.dart";
import "package:draya_mobile/features/teacher/reports/domain/usecases/get_performance_report_use_case.dart";
import "package:draya_mobile/features/teacher/reports/presentation/cubit/reports_cubit.dart";
import "package:draya_mobile/features/teacher/sections/domain/usecases/create_section_use_case.dart";
import "package:draya_mobile/features/teacher/sections/domain/usecases/delete_section_use_case.dart";
import "package:draya_mobile/features/teacher/sections/domain/usecases/get_sections_use_case.dart";
import "package:draya_mobile/features/teacher/sections/presentation/cubit/section_cubit.dart";
import "package:draya_mobile/features/teacher/subjects/domain/usecases/add_subject_use_case.dart";
import "package:draya_mobile/features/teacher/subjects/domain/usecases/get_subjects_use_case.dart";
import "package:draya_mobile/features/teacher/subjects/presentation/cubit/subject_cubit.dart";
import "package:draya_mobile/features/teacher/classrooms/domain/usecases/create_classroom_use_case.dart";
import "package:draya_mobile/features/teacher/classrooms/domain/usecases/get_classrooms_use_case.dart";
import "package:draya_mobile/features/teacher/classrooms/domain/usecases/get_classroom_students_use_case.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_cubit.dart";
import "package:draya_mobile/features/teacher/classrooms/presentation/cubit/classroom_students_cubit.dart";
import "package:draya_mobile/features/teacher/teacher_feedback/domain/usecases/get_classroom_feedback_use_case.dart";
import "package:draya_mobile/features/teacher/teacher_feedback/presentation/cubit/classroom_feedback_cubit.dart";
import "package:draya_mobile/features/teacher/teacher_feedback/presentation/cubit/teacher_feedback_cubit.dart";
import "package:draya_mobile/features/teacher/wallet/domain/usecases/confirm_payment_use_case.dart";
import "package:draya_mobile/features/teacher/wallet/domain/usecases/create_payout_account_use_case.dart";
import "package:draya_mobile/features/teacher/wallet/domain/usecases/create_withdrawal_use_case.dart";
import "package:draya_mobile/features/teacher/wallet/domain/usecases/delete_payout_account_use_case.dart";
import "package:draya_mobile/features/teacher/wallet/domain/usecases/get_payout_accounts_use_case.dart";
import "package:draya_mobile/features/teacher/wallet/domain/usecases/get_teacher_balance_use_case.dart";
import "package:draya_mobile/features/teacher/wallet/domain/usecases/get_transactions_use_case.dart";
import "package:draya_mobile/features/teacher/wallet/domain/usecases/get_withdrawals_use_case.dart";
import "package:draya_mobile/features/teacher/wallet/domain/usecases/top_up_use_case.dart";
import "package:draya_mobile/features/teacher/wallet/domain/usecases/update_payout_account_use_case.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/confirm_payment_cubit.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/payout_accounts_cubit.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/top_up_cubit.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/transactions_cubit.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/wallet_cubit.dart";
import "package:draya_mobile/features/teacher/wallet/presentation/cubit/withdrawals_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter/services.dart";
import "package:intl/date_symbol_data_local.dart";
import "app/draya_app.dart";

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
  await setupGetIt();
  getIt<DeepLinkService>().init();
  unawaited(getIt<LocalNotificationService>().init());
  await AppTokenHelper.clearSessionIfNotRemembered();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<SignupChoiceCubit>(
          create: (_) => SignupChoiceCubit(),
        ),
        BlocProvider<SigninCubit>(
          create: (_) => SigninCubit(getIt<LoginUseCase>()),
        ),
        BlocProvider<StudentSignupCubit>(
          create: (_) => StudentSignupCubit(getIt<StudentRegisterUseCase>()),
        ),
        BlocProvider<TeacherSignupCubit>(
          create: (_) => TeacherSignupCubit(getIt<TeacherRegisterUseCase>()),
        ),
        BlocProvider<LocaleCubit>(
          create: (context) => LocaleCubit(),
        ),
        BlocProvider<SubjectCubit>(
          create: (context) => SubjectCubit(
            getIt<AddSubjectUseCase>(),
            getIt<GetSubjectsUseCase>(),
          ),
        ),
        BlocProvider<ClassroomCubit>(
          create: (context) => ClassroomCubit(
            getIt<GetClassroomsUseCase>(),
            getIt<CreateClassroomUseCase>(),
            getIt<DeleteClassroomUseCase>(),
          ),
        ),
        BlocProvider<ClassroomTypesCubit>(
          create: (context) =>
              ClassroomTypesCubit(getIt<GetClassroomTypesUseCase>()),
        ),
        BlocProvider<GradeLevelsCubit>(
          create: (context) => GradeLevelsCubit(getIt<GetGradeLevelsUseCase>()),
        ),
        BlocProvider<ClassroomStudentsCubit>(
          create: (context) => ClassroomStudentsCubit(
            getIt<GetClassroomStudentsUseCase>(),
            getIt<DeleteClassroomStudentUseCase>(),
          ),
        ),
        BlocProvider<TeacherCubit>(
          create: (context) => TeacherCubit(getIt<GetTeachersUseCase>()),
        ),
        BlocProvider<TeacherClassroomsCubit>(
          create: (context) =>
              TeacherClassroomsCubit(getIt<GetTeacherClassroomsUseCase>()),
        ),
        BlocProvider<StudentEnrolledClassroomsCubit>(
          create: (context) => StudentEnrolledClassroomsCubit(
            getIt<GetStudentEnrolledClassroomsUseCase>(),
            getIt<EnrollClassroomUseCase>(),
          ),
        ),
        BlocProvider<StudentCheckoutCubit>(
          create: (context) =>
              StudentCheckoutCubit(getIt<CheckoutClassroomUseCase>()),
        ),
        BlocProvider<PaymentVerificationCubit>(
          create: (context) =>
              PaymentVerificationCubit(getIt<GetPaymentStatusUseCase>()),
        ),
        BlocProvider<StudentMaterialsCubit>(
          create: (context) => StudentMaterialsCubit(
            getIt<GetEnrolledMaterialsUseCase>(),
            getIt<GetMaterialStreamUseCase>(),
            getIt<GetClassroomSectionsUseCase>(),
          ),
        ),
        BlocProvider<TeacherProfileCubit>(
          create: (context) => TeacherProfileCubit(
            getIt<GetTeacherProfileUseCase>(),
            getIt<UploadTeacherProfilePictureUseCase>(),
            getIt<UpdateTeacherProfileUseCase>(),
          ),
        ),
        BlocProvider<StudentProfileCubit>(
          create: (context) => StudentProfileCubit(
            getIt<GetStudentProfileUseCase>(),
            getIt<UpdateStudentProfileUseCase>(),
            getIt<UploadStudentProfilePictureUseCase>(),
          ),
        ),
        BlocProvider<WalletCubit>(
          create: (context) => WalletCubit(getIt<GetTeacherBalanceUseCase>()),
        ),
        BlocProvider<TopUpCubit>(
          create: (context) => TopUpCubit(getIt<TopUpUseCase>()),
        ),
        BlocProvider<ConfirmPaymentCubit>(
          create: (context) =>
              ConfirmPaymentCubit(getIt<ConfirmPaymentUseCase>()),
        ),
        BlocProvider<TransactionsCubit>(
          create: (context) =>
              TransactionsCubit(getIt<GetTransactionsUseCase>()),
        ),
        BlocProvider<PayoutAccountsCubit>(
          create: (context) => PayoutAccountsCubit(
            getIt<GetPayoutAccountsUseCase>(),
            getIt<CreatePayoutAccountUseCase>(),
            getIt<UpdatePayoutAccountUseCase>(),
            getIt<DeletePayoutAccountUseCase>(),
          ),
        ),
        BlocProvider<WithdrawalsCubit>(
          create: (context) => WithdrawalsCubit(
            getIt<GetWithdrawalsUseCase>(),
            getIt<CreateWithdrawalUseCase>(),
          ),
        ),
        BlocProvider<MaterialsCubit>(
          create: (context) => MaterialsCubit(
            getIt<UploadMaterialsUseCase>(),
            getIt<GetMaterialsUseCase>(),
            getIt<DeleteMaterialUseCase>(),
          ),
        ),
        BlocProvider<SectionCubit>(
          create: (context) => SectionCubit(
            getIt<GetSectionsUseCase>(),
            getIt<CreateSectionUseCase>(),
            getIt<DeleteSectionUseCase>(),
          ),
        ),
        BlocProvider(
          create: (context) => TeacherDashboardCubit(
            getIt<GetTeacherDashboardUseCase>(),
          ),
        ),
        BlocProvider(
          create: (context) => StudentHomeCubit(
            getIt<GetStudentDashboardUseCase>(),
          ),
        ),
        BlocProvider(
          create: (context) => TeacherFeedbackCubit(
            getIt<GetClassroomsUseCase>(),
          ),
        ),
        BlocProvider(
          create: (context) => StudentFeedbackCubit(
            getIt<GetStudentEnrolledClassroomsUseCase>(),
            getIt<SubmitFeedbackUseCase>(),
          ),
        ),
        BlocProvider(
          create: (context) => ClassroomFeedbackCubit(
            getIt<GetClassroomFeedbackUseCase>(),
          ),
        ),
        BlocProvider(
          create: (context) => ReportsCubit(
            getIt<GetPerformanceReportUseCase>(),
          ),
        ),
      ],
      child: const DrayaApp(),
    ),
  );
}
