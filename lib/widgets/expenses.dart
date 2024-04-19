import 'package:flutter/material.dart';
import 'package:tracking_expenses/widgets/chart/chart.dart';
import 'package:tracking_expenses/widgets/expenses_list/expenses_list.dart';
import 'package:tracking_expenses/models/expense.dart';
import 'package:tracking_expenses/widgets/new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        amount: 19.99,
        date: DateTime.now(),
        title: 'Flutter Course',
        category: Category.work),
    Expense(
        amount: 15.99,
        date: DateTime.now(),
        title: 'Cinema',
        category: Category.leisure),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => Center(
                child: NewExpense(
              onAddExpense: _addExpense,
            )));
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted..'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = Center(
        child: Text(
      'No expenses registered, add some!',
      style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
    ));

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(
              Icons.add,
              size: 30,
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Chart(expenses: _registeredExpenses),
          Expanded(
            child: _registeredExpenses.isEmpty
                ? mainContent
                : ExpensesList(
                    onRemoveExpense: _removeExpense,
                    expenses: _registeredExpenses),
          ),
        ],
      ),
    );
  }
}
