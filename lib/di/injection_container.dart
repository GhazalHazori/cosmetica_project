import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/cubits/bottom_nav_cubit.dart';
import '../core/localization/localization_cubit.dart';
import '../core/network/api_client.dart';
import '../core/network/api_constants.dart';
import '../core/network/token_refresher.dart';
import '../core/network/token_storage.dart';
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
import '../features/otp_verification_feature/data/datasources/pending_verification_local_data_source.dart';
import '../features/otp_verification_feature/data/repositories/otp_verification_repository_impl.dart';
import '../features/otp_verification_feature/domain/repositories/otp_verification_repository.dart';
import '../features/otp_verification_feature/domain/usecases/otp_verification_use_case.dart';
import '../features/otp_verification_feature/presentation/cubit/otp_verification_cubit.dart';
import '../features/order_details_feature/data/datasources/order_details_remote_data_source.dart';
import '../features/order_details_feature/data/repositories/order_details_repository_impl.dart';
import '../features/order_details_feature/domain/repositories/order_details_repository.dart';
import '../features/order_details_feature/domain/usecases/get_order_details_use_case.dart';
import '../features/order_details_feature/presentation/cubit/order_details_cubit.dart';
import '../features/account_info_feature/data/datasources/account_info_remote_data_source.dart';
import '../features/account_info_feature/data/repositories/account_info_repository_impl.dart';
import '../features/account_info_feature/domain/repositories/account_info_repository.dart';
import '../features/account_info_feature/domain/usecases/account_info_usecases.dart';
import '../features/account_info_feature/presentation/cubit/account_info_cubit.dart';
import '../features/logout_feature/data/datasources/logout_remote_data_source.dart';
import '../features/logout_feature/data/repositories/logout_repository_impl.dart';
import '../features/logout_feature/domain/repositories/logout_repository.dart';
import '../features/logout_feature/domain/usecases/logout_use_case.dart';
import '../features/logout_feature/presentation/cubit/logout_cubit.dart';
import '../features/reset_password_feature/data/datasources/reset_password_remote_data_source.dart';
import '../features/reset_password_feature/data/repositories/reset_password_repository_impl.dart';
import '../features/reset_password_feature/domain/repositories/reset_password_repository.dart';
import '../features/reset_password_feature/domain/usecases/reset_password_usecases.dart';
import '../features/reset_password_feature/presentation/cubit/reset_password_cubit.dart';
import '../features/completed_order_details_feature/data/datasources/completed_order_details_remote_data_source.dart';
import '../features/completed_order_details_feature/data/repositories/completed_order_details_repository_impl.dart';
import '../features/completed_order_details_feature/domain/repositories/completed_order_details_repository.dart';
import '../features/completed_order_details_feature/domain/usecases/get_completed_order_details_use_case.dart';
import '../features/completed_order_details_feature/presentation/cubit/completed_order_details_cubit.dart';
import '../features/my_orders_feature/data/datasources/order_remote_data_source.dart';
import '../features/my_orders_feature/data/repositories/order_repository_impl.dart';
import '../features/my_orders_feature/domain/repositories/order_repository.dart';
import '../features/my_orders_feature/domain/usecases/order_usecases.dart';
import '../features/my_orders_feature/presentation/cubit/my_orders_cubit.dart';
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
import '../features/splash_feature/data/repositories/session_repository_impl.dart';
import '../features/splash_feature/domain/repositories/session_repository.dart';
import '../features/splash_feature/domain/usecases/restore_session_use_case.dart';
import '../features/splash_feature/presentation/cubit/splash_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
  sl.registerLazySingleton<LocalizationCubit>(() => LocalizationCubit());
  sl.registerFactory<BottomNavCubit>(() => BottomNavCubit());

  // Core: Network
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  sl.registerLazySingleton<TokenStorage>(
    () => SharedPrefsTokenStorage(sl()),
  );

  sl.registerLazySingleton<TokenRefresher>(
    () => TokenRefresher.withBaseUrl(
      tokenStorage: sl(),
      baseUrl: ApiConstants.baseUrl,
    ),
  );

  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      baseUrl: ApiConstants.baseUrl,
      tokenStorage: sl(),
      tokenRefresher: sl(),
      languageCode: () => sl<LocalizationCubit>().state.locale.languageCode,
    ),
  );

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
  sl.registerLazySingleton<SessionRepository>(
    () => SessionRepositoryImpl(tokenStorage: sl(), tokenRefresher: sl()),
  );

  sl.registerLazySingleton<RestoreSessionUseCase>(
    () => RestoreSessionUseCase(sl()),
  );

  sl.registerFactory<SplashCubit>(
    () => SplashCubit(sl(), sl()),
  );

  // Feature: Login
  sl.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(remoteDataSource: sl(), tokenStorage: sl()),
  );

  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl()),
  );

  sl.registerFactory<LoginCubit>(
    () => LoginCubit(sl()),
  );

  // Feature: Signup
  sl.registerLazySingleton<SignupRemoteDataSource>(
    () => SignupRemoteDataSourceImpl(sl()),
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
    () => BusinessSignupRemoteDataSourceImpl(sl()),
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
    () => OtpVerificationRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<PendingVerificationLocalDataSource>(
    () => PendingVerificationLocalDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<OtpVerificationRepository>(
    () => OtpVerificationRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(sl()),
  );

  sl.registerLazySingleton<ResendOtpUseCase>(
    () => ResendOtpUseCase(sl()),
  );

  sl.registerLazySingleton<GetPendingVerificationUseCase>(
    () => GetPendingVerificationUseCase(sl()),
  );

  sl.registerLazySingleton<SavePendingVerificationUseCase>(
    () => SavePendingVerificationUseCase(sl()),
  );

  sl.registerLazySingleton<ClearPendingVerificationUseCase>(
    () => ClearPendingVerificationUseCase(sl()),
  );

  sl.registerFactory<OtpVerificationCubit>(
    () => OtpVerificationCubit(sl(), sl(), sl(), sl()),
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
    () => ProfileRemoteDataSourceImpl(sl()),
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

  // Feature: My Orders
  sl.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<GetCurrentOrdersUseCase>(
    () => GetCurrentOrdersUseCase(sl()),
  );

  sl.registerLazySingleton<GetPastOrdersUseCase>(
    () => GetPastOrdersUseCase(sl()),
  );

  sl.registerFactory<MyOrdersCubit>(
    () => MyOrdersCubit(sl(), sl()),
  );

  // Feature: Order Details
  sl.registerLazySingleton<OrderDetailsRemoteDataSource>(
    () => OrderDetailsRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<OrderDetailsRepository>(
    () => OrderDetailsRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<GetOrderDetailsUseCase>(
    () => GetOrderDetailsUseCase(sl()),
  );

  sl.registerFactory<OrderDetailsCubit>(
    () => OrderDetailsCubit(sl()),
  );

  // Feature: Completed Order Details
  sl.registerLazySingleton<CompletedOrderDetailsRemoteDataSource>(
    () => CompletedOrderDetailsRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<CompletedOrderDetailsRepository>(
    () => CompletedOrderDetailsRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<GetCompletedOrderDetailsUseCase>(
    () => GetCompletedOrderDetailsUseCase(sl()),
  );

  sl.registerFactory<CompletedOrderDetailsCubit>(
    () => CompletedOrderDetailsCubit(sl()),
  );

  // Feature: Account Info
  sl.registerLazySingleton<AccountInfoRemoteDataSource>(
    () => AccountInfoRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<AccountInfoRepository>(
    () => AccountInfoRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<GetAccountInfoUseCase>(
    () => GetAccountInfoUseCase(sl()),
  );

  sl.registerLazySingleton<UpdateAccountInfoUseCase>(
    () => UpdateAccountInfoUseCase(sl()),
  );

  sl.registerLazySingleton<UpdateProfilePhotoUseCase>(
    () => UpdateProfilePhotoUseCase(sl()),
  );

  sl.registerFactory<AccountInfoCubit>(
    () => AccountInfoCubit(sl(), sl(), sl()),
  );

  // Feature: Reset Password
  sl.registerLazySingleton<ResetPasswordRemoteDataSource>(
    () => ResetPasswordRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<ResetPasswordRepository>(
    () => ResetPasswordRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<RequestResetCodeUseCase>(
    () => RequestResetCodeUseCase(sl()),
  );

  sl.registerLazySingleton<VerifyResetCodeUseCase>(
    () => VerifyResetCodeUseCase(sl()),
  );

  sl.registerLazySingleton<CompleteResetPasswordUseCase>(
    () => CompleteResetPasswordUseCase(sl()),
  );

  sl.registerFactory<ResetPasswordCubit>(
    () => ResetPasswordCubit(sl(), sl(), sl()),
  );

  // Feature: Logout
  sl.registerLazySingleton<LogoutRemoteDataSource>(
    () => LogoutRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<LogoutRepository>(
    () => LogoutRepositoryImpl(remoteDataSource: sl(), tokenStorage: sl()),
  );

  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(sl()),
  );

  sl.registerFactory<LogoutCubit>(
    () => LogoutCubit(sl()),
  );
}


