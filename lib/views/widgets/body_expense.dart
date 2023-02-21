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
      () => setState(() {}),
    );
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Titulo',
          ),
          controller: titleController,
        ),
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Valor',
          ),
          controller: valueController,
        ),
        TextButton(
          onPressed: () {
            setState(() {
              addUser;
            });
          },
          child: const Text(
            "Adicionar despesa",
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: usersList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var user = usersList[index];
              return ListTile(
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      deleteUser(user['id']);
                    });
                  },
                ),
                leading: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      updateUser(
                        user['id'],
                        !user['isPaid'],
                      );
                    });
                  },
                ),
                title: Text(user['title']),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "R\$ ${user['value']}",
                    ),
                    Text(
                      user['isPaid'] == false ? 'Não Pago' : 'Pago',
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
