import 'package:calculate_marriage/components/list_tile.dart';
import 'package:calculate_marriage/data/seed.dart';
import 'package:flutter/material.dart';

class ListHome extends StatelessWidget {
  const ListHome({super.key});

  @override
  Widget build(BuildContext context) {
    const list = {...SEED_LIST};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de gastos com o casamento'),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) => ListPage(
          listModel: list.values.elementAt(index),
        ),
      ),
    );
  }
}
