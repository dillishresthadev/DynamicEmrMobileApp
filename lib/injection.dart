import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dynamic_emr/core/network/connectivity_check.dart';
import 'package:dynamic_emr/core/network/dio_http_client.dart';
import 'package:dynamic_emr/features/auth/data/datasource/user_remote_datasource.dart';
import 'package:dynamic_emr/features/auth/data/repositories/user_repositories_impl.dart';
import 'package:dynamic_emr/features/auth/domain/repositories/user_repository.dart';
import 'package:dynamic_emr/features/auth/domain/usecases/fetch_hospital_base_url_usecase.dart';
import 'package:dynamic_emr/features/auth/domain/usecases/login_usecase.dart';
import 'package:dynamic_emr/features/auth/presentation/bloc/auth_bloc.dart';
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

  // Auth (user login)

  injection.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      loginUsecase: injection<LoginUsecase>(),
      hospitalBaseUrlUsecase: injection<FetchHospitalBaseUrlUsecase>(),
    ),
  );
  injection.registerLazySingleton<LoginUsecase>(
    () => LoginUsecase(repository: injection<UserRepository>()),
  );
  injection.registerLazySingleton<FetchHospitalBaseUrlUsecase>(
    () => FetchHospitalBaseUrlUsecase(repository: injection<UserRepository>()),
  );
  injection.registerLazySingleton<UserRepository>(
    () => UserRepositoriesImpl(
      remoteDataSource: injection<UserRemoteDataSource>(),
    ),
  );

  injection.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(client: injection<DioHttpClient>()),
  );
}
