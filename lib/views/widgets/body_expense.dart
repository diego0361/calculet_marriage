import 'package:brasil_fields/brasil_fields.dart';
import 'package:calculate_marriage/cards/cards_expenses.dart';
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
    bool isVisible = false;
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
            TextField(
              onChanged: (value) {
                updateListExpenses(value);
                setState(() {
                  isVisible = !isVisible;
                });
              },
              decoration: InputDecoration(
                labelText: 'Pesquisar',
                filled: true,
                fillColor: Colors.purple,
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
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
                itemCount: expensesSearch.isNotEmpty
                    ? expensesSearch.length
                    : expensesList.length,
                itemBuilder: (context, index) {
                  late ExpenseModel expense;
                  if (expensesSearch.isEmpty) {
                    expense = expensesList[index];
                  } else {
                    expense = expensesSearch[index];
                  }
                  return CardsExpenses(
                    onDelete: () {
                      setState(() {
                        deleteUser(expense.id ?? '');
                      });
                    },
                    isChecked: expense.isPaid,
                    onChanged: (bool? value) {
                      setState(() {
                        expense.isPaid = value!;
                      });
                    },
                    onExpense: expense,
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
