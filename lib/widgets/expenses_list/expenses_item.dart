import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tracking_expenses/main.dart';
import 'package:tracking_expenses/models/expense.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {Key? key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final isExpense = expense.type == TransactionType.expense;
    final IconData categoryIcon =
        isExpense ? categoryIcons[expense.category]! : Icons.attach_money;

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(),
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      isExpense
                          ? '-\$${expense.amount.toString()}'
                          : '+\$${expense.amount.toString()}',
                      style: TextStyle(
                          color: isExpense ? Colors.red : Colors.green),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          categoryIcon,
                          color: isDarkMode
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.65),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          expense.formattedDate,
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
