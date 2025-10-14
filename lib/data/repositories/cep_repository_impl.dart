import '../../domain/entities/cep_address.dart';
import '../../domain/repositories/cep_repository.dart';
import '../mappers/cep_address_mapper.dart';
import '../sources/remote/cep_remote_source.dart';

class CepRepositoryImpl implements CepRepository {
  final CepRemoteSource remote;

  CepRepositoryImpl(this.remote);

  @override
  Future<CepAddress> buscarCepRepo(String cep) async {
    final dto = await remote.buscarCep(cep);
    return dto.toDomain();
  }
}
