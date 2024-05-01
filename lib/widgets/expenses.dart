import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracking_expenses/widgets/chart/chart.dart';
import 'package:tracking_expenses/widgets/expenses_list/expenses_list.dart';
import 'package:tracking_expenses/models/expense.dart';
import 'package:tracking_expenses/widgets/new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({Key? key}) : super(key: key);

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        amount: 15.59,
        date: DateTime.now(),
        title: 'Pizza',
        category: Category.food,
        type: TransactionType.expense),
    Expense(
        amount: 19.99,
        date: DateTime.now(),
        title: 'Flutter Course',
        category: Category.work,
        type: TransactionType.expense),
    Expense(
        amount: 15.99,
        date: DateTime.now(),
        title: 'Cinema',
        category: Category.leisure,
        type: TransactionType.expense),
    Expense(
        amount: 2000,
        date: DateTime.now(),
        title: 'Salary',
        category: Category.leisure,
        type: TransactionType.income),
  ];

  double getTotalExpenses() {
    return _registeredExpenses
        .where((expense) => expense.type == TransactionType.expense)
        .map((expense) => expense.amount)
        .fold(0, (prev, amount) => prev + amount);
  }

  double getTotalIncome() {
    return _registeredExpenses
        .where((expense) => expense.type == TransactionType.income)
        .map((expense) => expense.amount)
        .fold(0, (prev, amount) => prev + amount);
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => Center(child: NewExpense(onAddExpense: _addExpense)),
    );
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
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final mainContent = _registeredExpenses.isEmpty
        ? Center(
            child: Text('No expenses registered, add some!',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade500)))
        : ExpensesList(
            onRemoveExpense: _removeExpense, expenses: _registeredExpenses);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker', style: TextStyle(fontSize: 20)),
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                _buildBudgetWidget(),
                const Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Text('My Expenses',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    SizedBox(),
                  ],
                ),
                Expanded(child: mainContent),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Column(children: [
                    Chart(expenses: _registeredExpenses),
                    Expanded(child: _buildBudgetWidget()),
                  ]),
                ),
                Expanded(child: mainContent),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet), label: 'wallet'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddExpenseOverlay,
        child: const Icon(Icons.add),
        elevation: 0.5,
      ),
    );
  }

  Widget _buildBudgetWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Income'),
              Text(
                'Budget',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
              Text('Expense'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '+${getTotalIncome().toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.green, fontSize: 16),
              ),
              Text(
                '${(getTotalIncome() - getTotalExpenses()).toStringAsFixed(2)}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.blue),
              ),
              Text(
                '-${getTotalExpenses().toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
