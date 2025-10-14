import 'package:flutter/material.dart';
import 'package:flutter_mvvm_designer_patterns/presentation/views/seach_cep.dart';

import 'app/di/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDI();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SearchCep(),
    );
  }
}