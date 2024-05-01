import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:tracking_expenses/main.dart';
import 'package:tracking_expenses/widgets/myTextField.dart';
import 'package:tracking_expenses/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({Key? key, required this.onAddExpense}) : super(key: key);

  final Function(Expense transaction) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  IncomeCategory _selectedIncomeCategory = IncomeCategory.salary;
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;
  TransactionType _selectedType = TransactionType.expense;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, amount, date, and category were entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, amount, date, and category were entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submitTransactionData() {
    final enteredAmount = double.tryParse(_priceController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      _showDialog();
      return;
    }
    widget.onAddExpense(
      Expense(
        amount: enteredAmount!,
        date: _selectedDate!,
        title: _titleController.text,
        category: _selectedCategory,
        type: _selectedType,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyBoardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 60, 16, keyBoardSpace + 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StyledTextField(
                    controller: _titleController,
                    label: 'Title',
                    hintText: 'Transaction title..',
                    isNumeric: false,
                    maxLength: 50,
                  ),
                  SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: StyledTextField(
                            controller: _priceController,
                            label: 'Amount',
                            hintText: 'Amount..',
                            isNumeric: true,
                            maxLength: null,
                          ),
                        ),
                        const SizedBox(width: 80),
                        Text(_selectedDate == null
                            ? 'No date selected'
                            : DateFormat.yMd().format(_selectedDate!)),
                        IconButton(
                          onPressed: _presentDatePicker,
                          icon: const Icon(Icons.date_range),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Income',
                          style: TextStyle(color: Colors.green, fontSize: 20)),
                      Switch(
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: kColorScheme.primary,
                        value: _selectedType == TransactionType.expense,
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value
                                ? TransactionType.expense
                                : TransactionType.income;
                          });
                        },
                      ),
                      Text('Expense',
                          style: TextStyle(color: Colors.red, fontSize: 20)),
                    ],
                  ),
                  if (_selectedType == TransactionType.income)
                    DropdownButton<IncomeCategory>(
                      value: _selectedIncomeCategory,
                      items: IncomeCategory.values.map((incomeCategory) {
                        return DropdownMenuItem<IncomeCategory>(
                          value: incomeCategory,
                          child: Text(
                            incomeCategory
                                .toString()
                                .split('.')
                                .last
                                .toUpperCase(),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          if (value == null) {
                            return;
                          }
                          _selectedIncomeCategory = value;
                        });
                      },
                    ),
                  if (_selectedType != TransactionType.income)
                    DropdownButton<Category>(
                      value: _selectedCategory,
                      items: Category.values.map((category) {
                        return DropdownMenuItem<Category>(
                          value: category,
                          child: Text(
                            category.toString().split('.').last.toUpperCase(),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          if (value == null) {
                            return;
                          }
                          _selectedCategory = value;
                        });
                      },
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _submitTransactionData();
                          _titleController.clear();
                          _priceController.clear();
                        },
                        child: const Text('Save Transaction'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
