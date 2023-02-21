import 'package:flutter/material.dart';

class CardTotalsMoney extends StatelessWidget {
  const CardTotalsMoney({
    Key? key,
    required this.totalString,
  }) : super(key: key);

  final String totalString;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(25),
      elevation: 10,
      shadowColor: Colors.purple,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          totalString,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
