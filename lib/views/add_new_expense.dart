// ignore_for_file: avoid_print

import 'package:calculate_marriage/views/expense_page_view.dart';
import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  final String title;
  final String value;
  final bool isPaid;

  const AddUser(this.title, this.value, this.isPaid, {super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection

    return const ExpensePageView();
  }
}
