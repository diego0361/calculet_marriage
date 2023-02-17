import 'package:calculate_marriage/models/list_model.dart';
import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key, this.listModel});

  final ListModel? listModel;

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: Text(''),
    );
  }
}
