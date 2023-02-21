// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/expense_model.dart';

class ExpenseController {
  CollectionReference expensesCollection =
      FirebaseFirestore.instance.collection('expenses');

  final titleController = TextEditingController();
  final valueController = TextEditingController();

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return expensesCollection
        .add(
          ExpenseModel(
            title: titleController.text,
            value: valueController.text,
            isPaid: false,
          ).toMap(),
        )
        .then(
          (value) => print("Expense Added"),
        )
        .whenComplete(() => getExpense())
        .catchError(
          (error) => print("Failed to add expense: $error"),
        );
  }

  List<Map<String, dynamic>> usersList = [];
  Future<void> getExpense() {
    return FirebaseFirestore.instance
        .collection('expenses')
        .get()
        .then((QuerySnapshot querySnapshot) {
      usersList = [];
      for (var doc in querySnapshot.docs) {
        print(doc);

        usersList.add(
          {
            'id': doc.reference.id,
            'title': doc['title'],
            'value': doc['value'],
            'isPaid': doc['isPaid'],
          },
        );
      }
    }).whenComplete(
            //() => setState(() {}),
            () {});
  }

  Future<void> updateUser(String id, bool isPaid) {
    return expensesCollection
        .doc(id)
        .update({'isPaid': isPaid})
        .then((value) => print("Expense Updated"))
        .whenComplete(() => getExpense())
        .catchError(
          (error) => print("Failed to update user: $error"),
        );
  }

  Future<void> deleteUser(String id) {
    return expensesCollection
        .doc(id)
        .delete()
        .then((value) => print("Expense Deleted"))
        .whenComplete(() => getExpense())
        .catchError(
          (error) => print("Failed to delete user: $error"),
        );
  }
}
