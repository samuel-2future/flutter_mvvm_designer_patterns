import '../entities/cep_address.dart';

abstract class CepRepository {
  Future<CepAddress> buscarCepRepo(String cep);
}
