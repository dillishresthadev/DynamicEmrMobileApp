import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dynamic_emr/core/local_storage/hospital_code_storage.dart';
import 'package:dynamic_emr/core/local_storage/token_storage.dart';
import 'package:dynamic_emr/core/network/connectivity_check.dart';
import 'package:dynamic_emr/core/network/dio_http_client.dart';
import 'package:dynamic_emr/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:dynamic_emr/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dynamic_emr/features/auth/domain/repositories/auth_repository.dart';
import 'package:dynamic_emr/features/auth/domain/usecases/fetch_hospital_base_url_usecase.dart';
import 'package:dynamic_emr/features/auth/domain/usecases/fetch_hospital_branch_usecase.dart';
import 'package:dynamic_emr/features/auth/domain/usecases/login_usecase.dart';
import 'package:dynamic_emr/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final injection = GetIt.instance;

Future<void> initDependencies() async {
  // External dependencies
  // final sharedPreferences = await SharedPreferences.getInstance();
  // injection.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Core
  injection.registerLazySingleton<Dio>(() => Dio());
  injection.registerLazySingleton(() => DioHttpClient(injection<Dio>()));
  injection.registerLazySingleton<ConnectivityCheck>(
    () => ConnectivityCheckImpl(connectivity: Connectivity()),
  );
  // Storage (Local Storage)
  injection.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  injection.registerLazySingleton<ISecureStorage>(
    () => HospitalCodeStorage(injection<FlutterSecureStorage>()),
  );
  // Token storage (access and refresh token)
  injection.registerLazySingleton<TokenSecureStorage>(
    () => TokenStorage(injection<FlutterSecureStorage>()),
  );
  // Auth (user login)

  injection.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      loginUsecase: injection<LoginUsecase>(),
      hospitalBaseUrlUsecase: injection<FetchHospitalBaseUrlUsecase>(),
      hospitalBranchUsecase: injection<FetchHospitalBranchUsecase>(),
    ),
  );
  injection.registerLazySingleton<LoginUsecase>(
    () => LoginUsecase(repository: injection<AuthRepository>()),
  );
  injection.registerLazySingleton<FetchHospitalBaseUrlUsecase>(
    () => FetchHospitalBaseUrlUsecase(repository: injection<AuthRepository>()),
  );
  injection.registerLazySingleton<FetchHospitalBranchUsecase>(
    () => FetchHospitalBranchUsecase(repository: injection<AuthRepository>()),
  );
  injection.registerLazySingleton<AuthRepository>(
    () =>
        AuthRepositoryImpl(remoteDataSource: injection<AuthRemoteDatasource>()),
  );

  injection.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDataSourceImpl(client: injection<DioHttpClient>()),
  );
}
