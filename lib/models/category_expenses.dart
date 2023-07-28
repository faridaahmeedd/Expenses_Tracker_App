import 'package:flutter/cupertino.dart';

import 'expense.dart';

class CategoryExpenses {
  List<Expense> expenses = [];
  final Map<Category, List<Expense>> categoryExpenses = Map<Category, List<Expense>>();

  CategoryExpenses({Key? key});

  List<Expense> get getExpenses => expenses;

  set setExpenses(List<Expense> expenses) {
    this.expenses = expenses;
    for (final category in Category.values) {
      categoryExpenses[category] = [];
    }
    print(categoryExpenses.keys.toList());
    print(categoryExpenses.values.toList());
    for (final expense in expenses) {
      if (categoryExpenses.containsKey(expense.category)) {
        categoryExpenses[expense.category]?.add(expense);
      } else {
        categoryExpenses[expense.category] = [expense];
      }
    }
  }

  double getTotalForCategory(Category category) {
    double total = 0;
    categoryExpenses[category]?.forEach((expense) => total += expense.amount);
    return total;
  }
}
