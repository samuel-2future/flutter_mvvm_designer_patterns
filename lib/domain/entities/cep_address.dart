// domain/entities/cep_address.dart
class CepAddress {
  final String cep, logradouro, bairro, localidade, uf;
  final String? complemento, ddd, ibge;
  const CepAddress({
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.localidade,
    required this.uf,
    this.complemento,
    this.ddd,
    this.ibge,
  });
}