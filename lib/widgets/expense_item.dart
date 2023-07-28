import 'package:expenses_tracker_app/models/expense.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expense;

  const ExpenseItem({Key? key, required this.expense}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          child: Icon(categoryIcons[expense.category]),
        ),
        title: Text(expense.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(expense.formattedTime),
            Text(expense.formattedDate),
          ],
        ),
        trailing: Text('${expense.amount} EGP',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
