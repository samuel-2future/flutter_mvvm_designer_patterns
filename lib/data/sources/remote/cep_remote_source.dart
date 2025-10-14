import '../../dtos/cep_address_dto.dart';
import '../../services/api_client.dart';

class CepRemoteSource {
  final ApiClient _api;

  CepRemoteSource(ApiClient? client)
      : _api = client ??
      ApiClient(
        baseUrl: 'https://viacep.com.br/',
        headers: {'Accept': 'application/json'},
      );

  Future<CepAddressDto> buscarCep(String cep) async {
    return _api.get<CepAddressDto>(
      '/ws/$cep/json/',
      parser: (json) => CepAddressDto.fromJson(json as Map<String, dynamic>),
    );
  }
}
