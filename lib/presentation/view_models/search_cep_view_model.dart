import 'package:flutter/material.dart';
import '../../domain/repositories/cep_repository.dart';
import '../../domain/value_objects/Cep.dart';

class SearchCepViewModel extends ChangeNotifier {
  final CepRepository repository;
  final TextEditingController cepCtrl;

  bool isLoading;
  String? error;

  final GlobalKey<FormState> formKey;

  SearchCepViewModel({
    required this.repository,
    TextEditingController? cepCtrl,
    this.isLoading = false,
    this.error,
    GlobalKey<FormState>? formKey})  : cepCtrl = cepCtrl ?? TextEditingController(),
        formKey = formKey ?? GlobalKey<FormState>();

  Future<void> buscarCep(BuildContext context) async {
    final cep = Cep.tryParse(cepCtrl.text);

    if (cep == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe um CEP com 8 dígitos.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Buscando CEP ${cep.value}...')),
    );

    try {
      final address = await repository.buscarCepRepo(cep.value);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          '${address.logradouro.isEmpty ? 'Logradouro não informado' : address.logradouro} - '
              '${address.bairro.isEmpty ? 'Bairro não informado' : address.bairro} - '
              '${address.localidade}/${address.uf}',
        )),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}
