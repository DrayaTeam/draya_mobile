import 'package:dio/dio.dart';
import 'package:draya_mobile/core/networking/dio_factory.dart';
import 'package:draya_mobile/features/auth/data/repos/auth_repo_impl.dart';
import 'package:draya_mobile/features/auth/data/source/auth_api_service.dart';
import 'package:draya_mobile/features/auth/domain/repos/auth_repo.dart';
import 'package:draya_mobile/features/auth/domain/usecases/login_use_case.dart';
import 'package:draya_mobile/features/auth/domain/usecases/student_register_use_case.dart';
import 'package:draya_mobile/features/auth/domain/usecases/teacher_register_use_case.dart';
import 'package:draya_mobile/features/student/teachers/data/repos/teacher_repo_impl.dart';
import 'package:draya_mobile/features/student/teachers/data/source/teacher_api_service.dart';
import 'package:draya_mobile/features/student/teachers/domain/repos/teacher_repo.dart';
import 'package:draya_mobile/features/student/teachers/domain/usecases/get_teacher_classrooms_use_case.dart';
import 'package:draya_mobile/features/student/teachers/domain/usecases/get_teachers_use_case.dart';
import 'package:draya_mobile/features/student/teachers/presentation/cubit/teacher_classrooms_cubit.dart';
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

  getIt.registerFactory<TeacherClassroomsCubit>(
    () => TeacherClassroomsCubit(getIt<GetTeacherClassroomsUseCase>()),
  );
}
