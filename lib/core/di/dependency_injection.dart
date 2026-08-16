import 'package:dio/dio.dart';
import 'package:draya_mobile/core/networking/dio_factory.dart';
import 'package:draya_mobile/core/signalr/signalr_service.dart';
import 'package:draya_mobile/core/signalr/signalr_client_service.dart';
import 'package:draya_mobile/features/auth/data/repos/auth_repo_impl.dart';
import 'package:draya_mobile/features/auth/data/source/auth_api_service.dart';
import 'package:draya_mobile/features/auth/domain/repos/auth_repo.dart';
import 'package:draya_mobile/features/auth/domain/usecases/get_current_user_profile_use_case.dart';
import 'package:draya_mobile/features/auth/domain/usecases/login_use_case.dart';
import 'package:draya_mobile/features/auth/domain/usecases/student_register_use_case.dart';
import 'package:draya_mobile/features/auth/domain/usecases/teacher_register_use_case.dart';
import 'package:draya_mobile/features/student/profile/data/repos/student_profile_repo_impl.dart';
import 'package:draya_mobile/features/student/profile/data/source/student_profile_api_service.dart';
import 'package:draya_mobile/features/student/profile/domain/repos/student_profile_repo.dart';
import 'package:draya_mobile/features/student/profile/domain/usecases/get_student_profile_use_case.dart';
import 'package:draya_mobile/features/student/profile/domain/usecases/update_student_profile_use_case.dart';
import 'package:draya_mobile/features/student/profile/presentation/cubit/student_profile_cubit.dart';
import 'package:draya_mobile/features/student/student_channel/data/repos/student_channel_repo_impl.dart';
import 'package:draya_mobile/features/student/student_channel/data/source/student_channel_remote_data_source.dart';
import 'package:draya_mobile/features/student/student_channel/domain/repos/student_channel_repo.dart';
import 'package:draya_mobile/features/student/student_channel/domain/usecases/create_question_use_case.dart';
import 'package:draya_mobile/features/student/student_channel/domain/usecases/create_reply_use_case.dart';
import 'package:draya_mobile/features/student/student_channel/domain/usecases/get_question_details_use_case.dart';
import 'package:draya_mobile/features/student/student_channel/domain/usecases/get_questions_use_case.dart';
import 'package:draya_mobile/features/student/student_channel/domain/usecases/unvote_question_use_case.dart';
import 'package:draya_mobile/features/student/student_channel/domain/usecases/vote_question_use_case.dart';
import 'package:draya_mobile/features/student/student_channel/presentation/cubit/student_channel_cubit.dart';
import 'package:draya_mobile/features/student/student_enrolled_classrooms/data/repos/student_enrolled_classrooms_repo_impl.dart';
import 'package:draya_mobile/features/student/student_enrolled_classrooms/data/source/student_enrolled_classrooms_api_service.dart';
import 'package:draya_mobile/features/student/student_enrolled_classrooms/domain/repos/student_enrolled_classrooms_repo.dart';
import 'package:draya_mobile/features/student/student_enrolled_classrooms/domain/usecases/enroll_classroom_use_case.dart';
import 'package:draya_mobile/features/student/student_enrolled_classrooms/domain/usecases/get_student_enrolled_classrooms_use_case.dart';
import 'package:draya_mobile/features/student/student_enrolled_classrooms/presentation/cubit/student_enrolled_classrooms_cubit.dart';
import 'package:draya_mobile/features/student/student_materials/data/repos/student_materials_repo_impl.dart';
import 'package:draya_mobile/features/student/student_materials/data/source/student_materials_api_service.dart';
import 'package:draya_mobile/features/student/student_materials/domain/repos/student_materials_repo.dart';
import 'package:draya_mobile/features/student/student_materials/domain/usecases/get_enrolled_materials_use_case.dart';
import 'package:draya_mobile/features/student/student_materials/domain/usecases/get_material_stream_use_case.dart';
import 'package:draya_mobile/features/student/student_materials/presentation/cubit/student_materials_cubit.dart';
import 'package:draya_mobile/features/student/teachers/data/repos/teacher_repo_impl.dart';
import 'package:draya_mobile/features/student/teachers/data/source/teacher_api_service.dart';
import 'package:draya_mobile/features/student/teachers/domain/repos/teacher_repo.dart';
import 'package:draya_mobile/features/student/teachers/domain/usecases/checkout_classroom_use_case.dart';
import 'package:draya_mobile/features/student/teachers/domain/usecases/get_teacher_classrooms_use_case.dart';
import 'package:draya_mobile/features/student/teachers/domain/usecases/get_teachers_use_case.dart';
import 'package:draya_mobile/features/student/teachers/presentation/cubit/student_checkout_cubit.dart';
import 'package:draya_mobile/features/student/teachers/presentation/cubit/teacher_classrooms_cubit.dart';
import 'package:draya_mobile/features/teacher/classrooms/domain/usecases/get_classroom_types_use_case.dart';
import 'package:draya_mobile/features/teacher/classrooms/domain/usecases/get_grade_levels_use_case.dart';
import 'package:draya_mobile/features/teacher/materials/data/repos/materials_repo_impl.dart';
import 'package:draya_mobile/features/teacher/materials/data/source/materials_api_service.dart';
import 'package:draya_mobile/features/teacher/materials/domain/repos/materials_repo.dart';
import 'package:draya_mobile/features/teacher/materials/domain/usecases/upload_materials_use_case.dart';
import 'package:draya_mobile/features/teacher/profile/data/repos/teacher_profile_repo_impl.dart';
import 'package:draya_mobile/features/teacher/profile/data/source/teacher_profile_api_service.dart';
import 'package:draya_mobile/features/teacher/profile/domain/repos/teacher_profile_repo.dart';
import 'package:draya_mobile/features/teacher/profile/domain/usecases/get_teacher_profile_use_case.dart';
import 'package:draya_mobile/features/teacher/subjects/data/repos/subject_repo_impl.dart';
import 'package:draya_mobile/features/teacher/subjects/data/source/subject_api_service.dart';
import 'package:draya_mobile/features/teacher/subjects/domain/repos/subject_repo.dart';
import 'package:draya_mobile/features/teacher/subjects/domain/usecases/add_subject_use_case.dart';
import 'package:draya_mobile/features/teacher/subjects/domain/usecases/get_subjects_use_case.dart';
import 'package:draya_mobile/features/teacher/classrooms/data/repos/classroom_repo_impl.dart';
import 'package:draya_mobile/features/teacher/classrooms/data/source/classroom_remote_data_source.dart';
import 'package:draya_mobile/features/teacher/classrooms/domain/repos/classroom_repo.dart';
import 'package:draya_mobile/features/teacher/classrooms/domain/usecases/create_classroom_use_case.dart';
import 'package:draya_mobile/features/teacher/classrooms/domain/usecases/delete_classroom_use_case.dart';
import 'package:draya_mobile/features/teacher/classrooms/domain/usecases/get_classroom_by_id_use_case.dart';
import 'package:draya_mobile/features/teacher/classrooms/domain/usecases/get_classroom_pricing_use_case.dart';
import 'package:draya_mobile/features/teacher/classrooms/domain/usecases/get_classroom_students_use_case.dart';
import 'package:draya_mobile/features/teacher/classrooms/domain/usecases/get_classrooms_use_case.dart';
import 'package:draya_mobile/features/teacher/classrooms/domain/usecases/regenerate_classroom_code_use_case.dart';
import 'package:draya_mobile/features/teacher/classrooms/domain/usecases/set_classroom_pricing_use_case.dart';
import 'package:draya_mobile/features/teacher/classrooms/domain/usecases/update_classroom_use_case.dart';
import 'package:draya_mobile/features/teacher/wallet/data/repos/wallet_repo_impl.dart';
import 'package:draya_mobile/features/teacher/wallet/data/source/wallet_api_service.dart';
import 'package:draya_mobile/features/teacher/wallet/domain/repos/wallet_repo.dart';
import 'package:draya_mobile/features/teacher/wallet/domain/usecases/confirm_payment_use_case.dart';
import 'package:draya_mobile/features/teacher/wallet/domain/usecases/get_teacher_balance_use_case.dart';
import 'package:draya_mobile/features/teacher/wallet/domain/usecases/top_up_use_case.dart';
import 'package:draya_mobile/features/teacher/wallet/presentation/cubit/confirm_payment_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  //dio
  final dio = await DioFactory.getDio();
  getIt.registerLazySingleton<Dio>(() => dio);

  // Auth
  getIt.registerLazySingleton<AuthApiService>(
    () => AuthApiService(getIt<Dio>()),
  );

  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepositoryImpl(getIt<AuthApiService>()),
  );

  getIt.registerLazySingleton<TeacherRegisterUseCase>(
    () => TeacherRegisterUseCase(getIt<AuthRepo>()),
  );

  getIt.registerLazySingleton<StudentRegisterUseCase>(
    () => StudentRegisterUseCase(getIt<AuthRepo>()),
  );

  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepo>()),
  );

  getIt.registerLazySingleton<GetCurrentUserProfileUseCase>(
    () => GetCurrentUserProfileUseCase(getIt<AuthRepo>()),
  );

  // student profile
  getIt.registerLazySingleton<StudentProfileApiService>(
    () => StudentProfileApiService(getIt<Dio>()),
  );

  getIt.registerLazySingleton<StudentProfileRepo>(
    () => StudentProfileRepoImpl(
      getIt<StudentProfileApiService>(),
      getIt<AuthApiService>(),
    ),
  );

  getIt.registerLazySingleton<GetStudentProfileUseCase>(
    () => GetStudentProfileUseCase(getIt<StudentProfileRepo>()),
  );

  getIt.registerLazySingleton<UpdateStudentProfileUseCase>(
    () => UpdateStudentProfileUseCase(getIt<StudentProfileRepo>()),
  );

  getIt.registerFactory<StudentProfileCubit>(
    () => StudentProfileCubit(
      getIt<GetStudentProfileUseCase>(),
      getIt<UpdateStudentProfileUseCase>(),
    ),
  );

  // subjects
  getIt.registerLazySingleton<SubjectApiService>(
    () => SubjectApiService(getIt<Dio>()),
  );

  getIt.registerLazySingleton<SubjectRepo>(
    () => SubjectRepoImpl(getIt<SubjectApiService>()),
  );

  getIt.registerLazySingleton<AddSubjectUseCase>(
    () => AddSubjectUseCase(getIt<SubjectRepo>()),
  );

  getIt.registerLazySingleton<GetSubjectsUseCase>(
    () => GetSubjectsUseCase(getIt<SubjectRepo>()),
  );

  // classrooms
  getIt.registerLazySingleton<ClassroomRemoteDataSource>(
    () => ClassroomRemoteDataSource(getIt<Dio>()),
  );

  getIt.registerLazySingleton<ClassroomRepo>(
    () => ClassroomRepoImpl(getIt<ClassroomRemoteDataSource>()),
  );

  getIt.registerLazySingleton<CreateClassroomUseCase>(
    () => CreateClassroomUseCase(getIt<ClassroomRepo>()),
  );
  getIt.registerLazySingleton<GetClassroomsUseCase>(
    () => GetClassroomsUseCase(getIt<ClassroomRepo>()),
  );
  getIt.registerLazySingleton<GetClassroomByIdUseCase>(
    () => GetClassroomByIdUseCase(getIt<ClassroomRepo>()),
  );
  getIt.registerLazySingleton<UpdateClassroomUseCase>(
    () => UpdateClassroomUseCase(getIt<ClassroomRepo>()),
  );
  getIt.registerLazySingleton<DeleteClassroomUseCase>(
    () => DeleteClassroomUseCase(getIt<ClassroomRepo>()),
  );
  getIt.registerLazySingleton<RegenerateClassroomCodeUseCase>(
    () => RegenerateClassroomCodeUseCase(getIt<ClassroomRepo>()),
  );
  getIt.registerLazySingleton<GetClassroomStudentsUseCase>(
    () => GetClassroomStudentsUseCase(getIt<ClassroomRepo>()),
  );
  getIt.registerLazySingleton<SetClassroomPricingUseCase>(
    () => SetClassroomPricingUseCase(getIt<ClassroomRepo>()),
  );
  getIt.registerLazySingleton<GetClassroomPricingUseCase>(
    () => GetClassroomPricingUseCase(getIt<ClassroomRepo>()),
  );

  getIt.registerLazySingleton<GetClassroomTypesUseCase>(
    () => GetClassroomTypesUseCase(getIt<ClassroomRepo>()),
  );

  getIt.registerLazySingleton<GetGradeLevelsUseCase>(
    () => GetGradeLevelsUseCase(getIt<ClassroomRepo>()),
  );

  // teacher profile
  getIt.registerLazySingleton<TeacherProfileApiService>(
    () => TeacherProfileApiService(getIt<Dio>()),
  );

  getIt.registerLazySingleton<TeacherProfileRepo>(
    () => TeacherProfileRepoImpl(getIt<TeacherProfileApiService>()),
  );

  getIt.registerLazySingleton<GetTeacherProfileUseCase>(
    () => GetTeacherProfileUseCase(getIt<TeacherProfileRepo>()),
  );

  // wallet
  getIt.registerLazySingleton<WalletApiService>(
    () => WalletApiService(getIt<Dio>()),
  );

  getIt.registerLazySingleton<WalletRepo>(
    () => WalletRepoImpl(getIt<WalletApiService>()),
  );

  getIt.registerLazySingleton<GetTeacherBalanceUseCase>(
    () => GetTeacherBalanceUseCase(getIt<WalletRepo>()),
  );

  getIt.registerLazySingleton<TopUpUseCase>(
    () => TopUpUseCase(getIt<WalletRepo>()),
  );

  getIt.registerLazySingleton<ConfirmPaymentUseCase>(
    () => ConfirmPaymentUseCase(getIt<WalletRepo>()),
  );

  getIt.registerFactory<ConfirmPaymentCubit>(
    () => ConfirmPaymentCubit(getIt<ConfirmPaymentUseCase>()),
  );

  // student teachers
  getIt.registerLazySingleton<TeacherApiService>(
    () => TeacherApiService(getIt<Dio>()),
  );

  getIt.registerLazySingleton<TeacherRepo>(
    () => TeacherRepoImpl(getIt<TeacherApiService>()),
  );

  getIt.registerLazySingleton<GetTeachersUseCase>(
    () => GetTeachersUseCase(getIt<TeacherRepo>()),
  );

  getIt.registerLazySingleton<GetTeacherClassroomsUseCase>(
    () => GetTeacherClassroomsUseCase(getIt<TeacherRepo>()),
  );

  getIt.registerLazySingleton<StudentEnrolledClassroomsApiService>(
    () => StudentEnrolledClassroomsApiService(getIt<Dio>()),
  );

  getIt.registerLazySingleton<StudentEnrolledClassroomsRepo>(
    () => StudentEnrolledClassroomsRepoImpl(
      getIt<StudentEnrolledClassroomsApiService>(),
    ),
  );

  getIt.registerLazySingleton<GetStudentEnrolledClassroomsUseCase>(
    () => GetStudentEnrolledClassroomsUseCase(
      getIt<StudentEnrolledClassroomsRepo>(),
    ),
  );

  getIt.registerLazySingleton<EnrollClassroomUseCase>(
    () => EnrollClassroomUseCase(
      getIt<StudentEnrolledClassroomsRepo>(),
    ),
  );

  getIt.registerLazySingleton<CheckoutClassroomUseCase>(
    () => CheckoutClassroomUseCase(getIt<TeacherRepo>()),
  );

  getIt.registerFactory<TeacherClassroomsCubit>(
    () => TeacherClassroomsCubit(getIt<GetTeacherClassroomsUseCase>()),
  );

  getIt.registerFactory<StudentEnrolledClassroomsCubit>(
    () => StudentEnrolledClassroomsCubit(
      getIt<GetStudentEnrolledClassroomsUseCase>(),
      getIt<EnrollClassroomUseCase>(),
    ),
  );

  getIt.registerFactory<StudentCheckoutCubit>(
    () => StudentCheckoutCubit(getIt<CheckoutClassroomUseCase>()),
  );

  // student materials
  getIt.registerLazySingleton<StudentMaterialsApiService>(
    () => StudentMaterialsApiService(getIt<Dio>()),
  );

  getIt.registerLazySingleton<StudentMaterialsRepo>(
    () => StudentMaterialsRepoImpl(getIt<StudentMaterialsApiService>()),
  );

  getIt.registerLazySingleton<GetEnrolledMaterialsUseCase>(
    () => GetEnrolledMaterialsUseCase(getIt<StudentMaterialsRepo>()),
  );

  getIt.registerLazySingleton<GetMaterialStreamUseCase>(
    () => GetMaterialStreamUseCase(getIt<StudentMaterialsRepo>()),
  );

  getIt.registerFactory<StudentMaterialsCubit>(
    () => StudentMaterialsCubit(
      getIt<GetEnrolledMaterialsUseCase>(),
      getIt<GetMaterialStreamUseCase>(),
    ),
  );

  // SignalR Service
  getIt.registerLazySingleton<SignalRService>(
    () => SignalRClientService(),
  );

  // Student Channel (Q&A)
  getIt.registerLazySingleton<StudentChannelRemoteDataSource>(
    () => StudentChannelRemoteDataSource(getIt<Dio>()),
  );

  getIt.registerLazySingleton<StudentChannelRepo>(
    () => StudentChannelRepoImpl(getIt<StudentChannelRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetQuestionsUseCase>(
    () => GetQuestionsUseCase(getIt<StudentChannelRepo>()),
  );

  getIt.registerLazySingleton<CreateQuestionUseCase>(
    () => CreateQuestionUseCase(getIt<StudentChannelRepo>()),
  );

  getIt.registerLazySingleton<GetQuestionDetailsUseCase>(
    () => GetQuestionDetailsUseCase(getIt<StudentChannelRepo>()),
  );

  getIt.registerLazySingleton<CreateReplyUseCase>(
    () => CreateReplyUseCase(getIt<StudentChannelRepo>()),
  );

  getIt.registerLazySingleton<VoteQuestionUseCase>(
    () => VoteQuestionUseCase(getIt<StudentChannelRepo>()),
  );

  getIt.registerLazySingleton<UnvoteQuestionUseCase>(
    () => UnvoteQuestionUseCase(getIt<StudentChannelRepo>()),
  );

  getIt.registerFactory<StudentChannelCubit>(
    () => StudentChannelCubit(
      getIt<GetQuestionsUseCase>(),
      getIt<CreateQuestionUseCase>(),
      getIt<GetQuestionDetailsUseCase>(),
      getIt<CreateReplyUseCase>(),
      getIt<VoteQuestionUseCase>(),
      getIt<UnvoteQuestionUseCase>(),
      getIt<SignalRService>(),
    ),
  );
  // materials
  getIt.registerLazySingleton<MaterialsApiService>(
    () => MaterialsApiService(getIt<Dio>()),
  );

  getIt.registerLazySingleton<MaterialsRepo>(
    () => MaterialsRepoImpl(getIt<MaterialsApiService>()),
  );

  getIt.registerLazySingleton<UploadMaterialsUseCase>(
    () => UploadMaterialsUseCase(getIt<MaterialsRepo>()),
  );
}
