import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/expense_model.dart';

class Common extends StatefulWidget {
  const Common({Key? key}) : super(key: key);

  @override
  State<Common> createState() => _CommonState();
}

class _CommonState extends State<Common> {
  List<ExpenseModel> expensesSearch = [];

  void updateListExpenses(String value) {
    expensesSearch = expensesList.where((element) {
      return element.title.toLowerCase().contains(value.toLowerCase());
    }).toList();

    if (mounted) {
      setState(() {});
    }
  }

  CollectionReference expensesCollection =
      FirebaseFirestore.instance.collection('expenses');

  final titleController = TextEditingController();
  final valueController = TextEditingController();

  double totalExpense = 0;
  double totalPending = 0;
  double totalPaid = 0;

  Future<void> addExpense() async {
    if (titleController.text.isEmpty || valueController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Os campos não podem ficarem vazio')),
      );
      return;
    }
    expensesCollection
        .add(ExpenseModel(
          title: titleController.text,
          value: double.tryParse(valueController.text.replaceAll('.', '')) ?? 0,
          isPaid: false,
        ).toMap())
        .then((value) => debugPrint("Expense Added"))
        .whenComplete(
      () {
        titleController.clear();
        valueController.clear();
        getExpense();
      },
    ).catchError((error) => debugPrint("Failed to add expense: $error"));
  }

  List<ExpenseModel> expensesList = [];
  Future<void> getExpense() async {
    return FirebaseFirestore.instance
        .collection('expenses')
        .get()
        .then((QuerySnapshot querySnapshot) {
      expensesList = [];
      totalExpense = 0;
      totalPaid = 0;
      totalPending = 0;

      for (var doc in querySnapshot.docs) {
        final expense = ExpenseModel(
          id: doc.reference.id,
          title: doc['title'],
          value: double.tryParse(doc['value'].toString()) ?? 0,
          isPaid: doc['isPaid'],
        );
        if (expense.isPaid) {
          totalPaid += expense.value;
        } else {
          totalPending += expense.value;
        }
        totalExpense += expense.value;
        expensesList.add(expense);
      }
    }).whenComplete(() => setState(() {}));
  }

  Future<void> updateExpense(String id, bool isPaid) async {
    expensesCollection
        .doc(id)
        .update({'isPaid': isPaid})
        .then((value) => debugPrint("Expense Updated"))
        .whenComplete(() => getExpense())
        .catchError((error) => debugPrint("Failed to update user: $error"));
  }

  Future<void> deleteUser(String id) async {
    expensesCollection
        .doc(id)
        .delete()
        .then((value) => debugPrint("Expense Deleted"))
        .whenComplete(() => getExpense())
        .catchError(
          (error) => debugPrint("Failed to delete user: $error"),
        );
  }

  @override
  Widget build(BuildContext context) {
    return build(context);
  }
}
