import 'package:get_it/get_it.dart';
import '../../data/services/api_client.dart';
import '../../data/sources/remote/cep_remote_source.dart';
import '../../data/repositories/cep_repository_impl.dart';
import '../../domain/repositories/cep_repository.dart';

final sl = GetIt.instance;

Future<void> setupDI() async {
  sl.registerLazySingleton<ApiClient>(() => ApiClient(baseUrl: 'https://viacep.com.br/'),);
  sl.registerLazySingleton<CepRemoteSource>(() => CepRemoteSource(sl<ApiClient>()),);
  sl.registerLazySingleton<CepRepository>(() => CepRepositoryImpl(sl<CepRemoteSource>()),);
}
