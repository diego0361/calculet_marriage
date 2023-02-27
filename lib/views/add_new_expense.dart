// ignore_for_file: avoid_print

import 'package:calculate_marriage/views/expense_page_view.dart';
import 'package:flutter/material.dart';

class AddExpense extends StatefulWidget {
  final String title;
  final String value;
  final bool isPaid;

  const AddExpense(this.title, this.value, this.isPaid, {super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection

    return const ExpensePageView();
  }
}
