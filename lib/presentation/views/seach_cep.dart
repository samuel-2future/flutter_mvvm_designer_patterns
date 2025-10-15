import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app/di/injector.dart';
import '../../domain/repositories/cep_repository.dart';
import '../view_model/search_cep_view_model.dart';

class SearchCep extends StatefulWidget {
  const SearchCep({super.key});

  @override
  State<SearchCep> createState() => _SearchCepState();
}

class _SearchCepState extends State<SearchCep> {
  final vm = SearchCepViewModel(repository: sl<CepRepository>());

  @override
  void dispose() {
    vm.cepCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pesquisa de CEP')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: vm.cepCtrl,
                decoration: const InputDecoration(
                  labelText: 'CEP',
                  hintText: 'Apenas números (8 dígitos)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) async => await vm.buscarCep(context),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              height: 55,
              child: FilledButton.icon(
                onPressed: () async =>  await vm.buscarCep(context),
                icon: const Icon(Icons.search),
                label: const Text('Buscar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
