import 'package:calculate_marriage/views/add_new_expense.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora do Amor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AddUser('Aluguel', '2500', false),
    );
  }
}
