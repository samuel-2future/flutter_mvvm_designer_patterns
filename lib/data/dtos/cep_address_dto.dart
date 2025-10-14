// data/dtos/cep_address_dto.dart
class CepAddressDto {
  final String cep, logradouro, bairro, localidade, uf;
  final String? complemento, ddd, ibge;

  CepAddressDto({
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.localidade,
    required this.uf,
    this.complemento,
    this.ddd,
    this.ibge,
  });

  factory CepAddressDto.fromJson(Map<String, dynamic> json) {
    if (json['erro'] == true) {
      throw const FormatException('CEP não encontrado');
    }
    return CepAddressDto(
      cep: (json['cep'] ?? '').toString(),
      logradouro: (json['logradouro'] ?? '').toString(),
      bairro: (json['bairro'] ?? '').toString(),
      localidade: (json['localidade'] ?? '').toString(),
      uf: (json['uf'] ?? '').toString(),
      complemento: json['complemento']?.toString(),
      ddd: json['ddd']?.toString(),
      ibge: json['ibge']?.toString(),
    );
  }
}
