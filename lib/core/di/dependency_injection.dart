import 'package:dio/dio.dart';
import 'package:draya_mobile/core/networking/dio_factory.dart';
import 'package:draya_mobile/features/auth/data/repos/auth_repo_impl.dart';
import 'package:draya_mobile/features/auth/data/source/auth_api_service.dart';
import 'package:draya_mobile/features/auth/domain/repos/auth_repo.dart';
import 'package:draya_mobile/features/auth/domain/usecases/login_use_case.dart';
import 'package:draya_mobile/features/auth/domain/usecases/student_register_use_case.dart';
import 'package:draya_mobile/features/auth/domain/usecases/teacher_register_use_case.dart';
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

  
}
