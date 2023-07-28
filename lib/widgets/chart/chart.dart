import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:expenses_tracker_app/widgets/chart/chart_bar.dart';
import 'package:expenses_tracker_app/models/expense.dart';
import 'package:expenses_tracker_app/models/category_expenses.dart';

import '../../main.dart';

class Chart extends StatelessWidget {
  final List<Expense> expenses;
  final CategoryExpenses buckets = CategoryExpenses();

  Chart({super.key, required this.expenses}) {
    buckets.setExpenses = expenses;
  }

  double get maxTotalExpense {
    double maxTotalExpense = 0;
    buckets.categoryExpenses.forEach((key, value) {
      if (buckets.getTotalForCategory(key) > maxTotalExpense) {
        maxTotalExpense = buckets.getTotalForCategory(key);
      }
    });
    return maxTotalExpense;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [colorScheme.primary.withOpacity(0.3), colorScheme.primary.withOpacity(0.0)],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (MapEntry item in buckets.categoryExpenses.entries) // alternative to map()
                  ChartBar(
                    fill: buckets.getTotalForCategory(item.key) == 0
                        ? 0
                        : buckets.getTotalForCategory(item.key) / maxTotalExpense,
                  )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: buckets.categoryExpenses.keys
                .map(
                  (bucket) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        categoryIcons[bucket],
                        color: isDarkMode
                            ? darkColorScheme.secondary.withOpacity(0.8)
                            : colorScheme.secondary.withOpacity(0.8),
                      ),
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
