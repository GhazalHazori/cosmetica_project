import 'package:get_it/get_it.dart';

import '../core/localization/localization_cubit.dart';
import '../core/theme/theme_cubit.dart';
import '../features/login_feature/data/datasources/login_remote_data_source.dart';
import '../features/login_feature/data/repositories/login_repository_impl.dart';
import '../features/login_feature/domain/repositories/login_repository.dart';
import '../features/login_feature/domain/usecases/login_use_case.dart';
import '../features/login_feature/presentation/cubit/login_cubit.dart';
import '../features/sample_feature/data/datasources/sample_remote_data_source.dart';
import '../features/sample_feature/data/repositories/sample_repository_impl.dart';
import '../features/sample_feature/domain/repositories/sample_repository.dart';
import '../features/sample_feature/domain/usecases/get_samples_use_case.dart';
import '../features/sample_feature/presentation/cubit/sample_cubit.dart';
import '../features/splash_feature/presentation/cubit/splash_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  sl.registerLazySingleton<LocalizationCubit>(() => LocalizationCubit());

  // Feature: Sample
  sl.registerLazySingleton<SampleRemoteDataSource>(
    () => SampleRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<SampleRepository>(
    () => SampleRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<GetSamplesUseCase>(
    () => GetSamplesUseCase(sl()),
  );

  sl.registerFactory<SampleCubit>(
    () => SampleCubit(getSamplesUseCase: sl()),
  );

  // Feature: Splash
  sl.registerFactory<SplashCubit>(
    () => SplashCubit(),
  );

  // Feature: Login
  sl.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl()),
  );

  sl.registerFactory<LoginCubit>(
    () => LoginCubit(sl()),
  );
}


