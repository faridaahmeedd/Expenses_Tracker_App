import 'package:expenses_tracker_app/widgets/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:expenses_tracker_app/models/expense.dart';

import '../main.dart';

class ExpensesList extends StatelessWidget {
  final List<Expense> expenses;
  final Function deleteExpense;

  const ExpensesList({Key? key, required this.expenses, required this.deleteExpense})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(expenses.isEmpty) {
      return const Center(child: Text('No expenses added yet!', style: TextStyle(fontSize: 18)));
    }
    return ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          return Dismissible(
              key: ValueKey(expenses[index]),
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 10),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: colorScheme.error,
                ),
                child: Icon(Icons.delete, color: colorScheme.onPrimary, size: 40),
              ),
              onDismissed: (direction) => deleteExpense(expenses[index]),
              child: ExpenseItem(expense: expenses[index]),
            );
        });
  }
}
