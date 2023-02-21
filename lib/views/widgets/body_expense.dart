// ignore_for_file: avoid_print

//import 'package:calculate_marriage/views/expense_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/expense_model.dart';

class BodyExpense extends StatefulWidget {
  const BodyExpense({Key? key}) : super(key: key);

  @override
  State<BodyExpense> createState() => _BodyExpenseState();
}

class _BodyExpenseState extends State<BodyExpense> {
  //final ExpenseController expenseController = ExpenseController();

  @override
  void initState() {
    getExpense();
    super.initState();
  }

  CollectionReference expensesCollection =
      FirebaseFirestore.instance.collection('expenses');

  final titleController = TextEditingController();
  final valueController = TextEditingController();

  double totalValue = 0;
  double totalPending = 0;
  double totalPaid = 0;

  Future<void> addExpense() {
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
        .whenComplete(
      () {
        titleController.text = '';
        valueController.text = '';
        getExpense();
      },
    ).catchError(
      (error) => print("Failed to add expense: $error"),
    );
  }

  List<Map<String, dynamic>> expensesList = [];
  Future<void> getExpense() {
    return FirebaseFirestore.instance
        .collection('expenses')
        .get()
        .then((QuerySnapshot querySnapshot) {
      expensesList = [];
      totalValue = 0;
      totalPaid = 0;
      totalPending = 0;

      for (var doc in querySnapshot.docs) {
        if (doc['isPaid']) {
          totalPaid += double.parse(doc['value']);
        } else {
          totalPending += double.parse(doc['value']);
        }

        totalValue += double.parse(doc['value']);

        print(doc);

        expensesList.add(
          {
            'id': doc.reference.id,
            'title': doc['title'],
            'value': doc['value'],
            'isPaid': doc['isPaid'],
          },
        );
      }
    }).whenComplete(
      () => setState(() {}),
    );
  }

  Future<void> updateExpense(String id, bool isPaid) {
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Titulo',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              controller: titleController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Valor',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              controller: valueController,
            ),
          ),
          TextButton(
            onPressed: () {
              addExpense();
            },
            child: const Text(
              "Adicionar despesa",
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: expensesList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var expense = expensesList[index];
                return ListTile(
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        deleteUser(expense['id']);
                      });
                    },
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        updateExpense(
                          expense['id'],
                          !expense['isPaid'],
                        );
                      });
                    },
                  ),
                  title: Text(expense['title']),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "R\$ ${expense['value']}",
                      ),
                      Text(
                        expense['isPaid'] == false
                            ? 'PENDENTE'
                            : 'NÃO PENDENTE ',
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: Text(
              'Total: $totalValue Total pendente: $totalPending Total pago: $totalPaid',
            ),
          )
        ],
      ),
    );
  }
}
