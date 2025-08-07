import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dynamic_emr/core/network/connectivity_check.dart';
import 'package:dynamic_emr/core/network/dio_http_client.dart';
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
}
