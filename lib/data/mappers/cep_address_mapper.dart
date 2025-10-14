import '../../domain/entities/cep_address.dart';
import '../dtos/cep_address_dto.dart';

extension CepAddressMapper on CepAddressDto {
  CepAddress toDomain() => CepAddress(
    cep: cep,
    logradouro: logradouro,
    bairro: bairro,
    localidade: localidade,
    uf: uf,
    complemento: complemento,
    ddd: ddd,
    ibge: ibge,
  );
}
