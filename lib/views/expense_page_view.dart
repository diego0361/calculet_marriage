import 'package:calculate_marriage/views/widgets/body_expense.dart';
import 'package:flutter/material.dart';

class ExpensePageView extends StatelessWidget {
  const ExpensePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BodyExpense(),
    );
  }
}
