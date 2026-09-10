import 'package:get_it/get_it.dart';

import '../core/cubits/bottom_nav_cubit.dart';
import '../core/localization/localization_cubit.dart';
import '../core/theme/theme_cubit.dart';
import '../features/business_signup_feature/data/datasources/business_signup_remote_data_source.dart';
import '../features/business_signup_feature/data/repositories/business_signup_repository_impl.dart';
import '../features/business_signup_feature/domain/repositories/business_signup_repository.dart';
import '../features/business_signup_feature/domain/usecases/business_signup_use_case.dart';
import '../features/business_signup_feature/presentation/cubit/business_signup_cubit.dart';
import '../features/login_feature/data/datasources/login_remote_data_source.dart';
import '../features/login_feature/data/repositories/login_repository_impl.dart';
import '../features/login_feature/domain/repositories/login_repository.dart';
import '../features/login_feature/domain/usecases/login_use_case.dart';
import '../features/login_feature/presentation/cubit/login_cubit.dart';
import '../features/otp_verification_feature/data/datasources/otp_verification_remote_data_source.dart';
import '../features/otp_verification_feature/data/repositories/otp_verification_repository_impl.dart';
import '../features/otp_verification_feature/domain/repositories/otp_verification_repository.dart';
import '../features/otp_verification_feature/domain/usecases/otp_verification_use_case.dart';
import '../features/otp_verification_feature/presentation/cubit/otp_verification_cubit.dart';
import '../features/payment_methods_feature/data/datasources/payment_method_remote_data_source.dart';
import '../features/payment_methods_feature/data/repositories/payment_method_repository_impl.dart';
import '../features/payment_methods_feature/domain/repositories/payment_method_repository.dart';
import '../features/payment_methods_feature/domain/usecases/get_payment_methods_use_case.dart';
import '../features/payment_methods_feature/presentation/cubit/payment_methods_cubit.dart';
import '../features/sample_feature/data/datasources/sample_remote_data_source.dart';
import '../features/sample_feature/data/repositories/sample_repository_impl.dart';
import '../features/sample_feature/domain/repositories/sample_repository.dart';
import '../features/sample_feature/domain/usecases/get_samples_use_case.dart';
import '../features/sample_feature/presentation/cubit/sample_cubit.dart';
import '../features/search_feature/data/datasources/category_remote_data_source.dart';
import '../features/search_feature/data/repositories/category_repository_impl.dart';
import '../features/search_feature/domain/repositories/category_repository.dart';
import '../features/search_feature/domain/usecases/category_usecases.dart';
import '../features/search_feature/presentation/cubit/search_cubit.dart';
import '../features/profile_feature/data/datasources/profile_remote_data_source.dart';
import '../features/profile_feature/data/repositories/profile_repository_impl.dart';
import '../features/profile_feature/domain/repositories/profile_repository.dart';
import '../features/profile_feature/domain/usecases/get_profile_use_case.dart';
import '../features/profile_feature/presentation/cubit/profile_cubit.dart';
import '../features/signup_feature/data/datasources/signup_remote_data_source.dart';
import '../features/signup_feature/data/repositories/signup_repository_impl.dart';
import '../features/signup_feature/domain/repositories/signup_repository.dart';
import '../features/signup_feature/domain/usecases/signup_use_case.dart';
import '../features/signup_feature/presentation/cubit/signup_cubit.dart';
import '../features/splash_feature/presentation/cubit/splash_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  sl.registerLazySingleton<LocalizationCubit>(() => LocalizationCubit());
  sl.registerFactory<BottomNavCubit>(() => BottomNavCubit());

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

  // Feature: Signup
  sl.registerLazySingleton<SignupRemoteDataSource>(
    () => SignupRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<SignupRepository>(
    () => SignupRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<SignupUseCase>(
    () => SignupUseCase(sl()),
  );

  sl.registerFactory<SignupCubit>(
    () => SignupCubit(sl()),
  );

  // Feature: Business Signup
  sl.registerLazySingleton<BusinessSignupRemoteDataSource>(
    () => BusinessSignupRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<BusinessSignupRepository>(
    () => BusinessSignupRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<BusinessSignupUseCase>(
    () => BusinessSignupUseCase(sl()),
  );

  sl.registerFactory<BusinessSignupCubit>(
    () => BusinessSignupCubit(sl()),
  );

  // Feature: OTP Verification
  sl.registerLazySingleton<OtpVerificationRemoteDataSource>(
    () => OtpVerificationRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<OtpVerificationRepository>(
    () => OtpVerificationRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(sl()),
  );

  sl.registerLazySingleton<ResendOtpUseCase>(
    () => ResendOtpUseCase(sl()),
  );

  sl.registerFactory<OtpVerificationCubit>(
    () => OtpVerificationCubit(sl(), sl()),
  );

  // Feature: Payment Methods
  sl.registerLazySingleton<PaymentMethodRemoteDataSource>(
    () => PaymentMethodRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<PaymentMethodRepository>(
    () => PaymentMethodRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<GetPaymentMethodsUseCase>(
    () => GetPaymentMethodsUseCase(sl()),
  );

  sl.registerFactory<PaymentMethodsCubit>(
    () => PaymentMethodsCubit(sl()),
  );

  // Feature: Search
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(sl()),
  );

  sl.registerLazySingleton<SearchCategoriesUseCase>(
    () => SearchCategoriesUseCase(sl()),
  );

  sl.registerFactory<SearchCubit>(
    () => SearchCubit(sl(), sl()),
  );

  // Feature: Profile
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(sl()),
  );

  sl.registerFactory<ProfileCubit>(
    () => ProfileCubit(sl()),
  );
}


