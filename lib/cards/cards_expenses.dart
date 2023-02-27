// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:calculate_marriage/models/expense_model.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CardsExpenses extends StatelessWidget {
  CardsExpenses({
    Key? key,
    required this.onExpense,
    this.onDelete,
    this.isChecked = false,
    required this.onChanged,
  }) : super(key: key);

  final ExpenseModel onExpense;
  final void Function()? onDelete;
  final bool isChecked;
  Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 12,
      ),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 225, 194, 233),
        ),
        child: ListTile(
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
          leading: Checkbox(
            value: isChecked,
            onChanged: onChanged,
          ),
          title: Text(onExpense.title),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 180),
                child: Text(
                  "R\$ ${onExpense.value}",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  onExpense.isPaid == false ? 'PENDENTE' : 'NÃO PENDENTE ',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
