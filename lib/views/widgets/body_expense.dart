import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/expense_model.dart';
import 'card_totals_money.dart';

class BodyExpense extends StatefulWidget {
  const BodyExpense({Key? key}) : super(key: key);

  @override
  State<BodyExpense> createState() => _BodyExpenseState();
}

class _BodyExpenseState extends State<BodyExpense> {
  @override
  void initState() {
    getExpense();
    super.initState();
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
    return SizedBox(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 228, 203, 135),
              Color.fromARGB(255, 91, 18, 100)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
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
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  RealInputFormatter(),
                ],
                decoration: InputDecoration(
                  hintText: 'Valor',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: valueController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.purple),
                ),
                onPressed: () {
                  addExpense();
                },
                child: const Text(
                  "Adicionar despesa",
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: expensesList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var expense = expensesList[index];
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
                          onPressed: () {
                            setState(() {
                              deleteUser(expense.id ?? '');
                            });
                          },
                        ),
                        leading: IconButton(
                          icon: Icon(
                            expense.isPaid == false
                                ? Icons.check_box_outline_blank
                                : Icons.check_box,
                            color: Colors.purple,
                          ),
                          onPressed: () {
                            setState(() {
                              updateExpense(
                                expense.id ?? '',
                                !expense.isPaid,
                              );
                            });
                          },
                        ),
                        title: Text(expense.title),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 180),
                              child: Text(
                                "R\$ ${expense.value}",
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Text(
                                expense.isPaid == false
                                    ? 'PENDENTE'
                                    : 'NÃO PENDENTE ',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CardTotalsMoney(totalString: 'Total Pago: $totalPaid'),
                  CardTotalsMoney(
                      totalString: 'Total Pendente : $totalPending'),
                  CardTotalsMoney(totalString: 'Total Despesas: $totalExpense'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
