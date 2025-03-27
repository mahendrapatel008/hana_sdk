import 'package:get_it/get_it.dart';
import 'package:hana_sdk/core/services/shared_pref.dart';
import 'package:hana_sdk/network/api_service.dart';
import 'package:hana_sdk/network/dio_factory.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  sl.registerLazySingleton(() => DioFactory());
  final dio = await sl<DioFactory>().getDio();
  sl.registerLazySingleton(() => SharedPrefs());
  sl.registerLazySingleton(() => ApiService(dio));
}
