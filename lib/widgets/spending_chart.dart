import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/transaction.dart';

class SpendingChart extends StatelessWidget {
  final List<FinanceTransaction> transactions;

  const SpendingChart({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    // Get expenses only
    final expenses = transactions.where((t) => !t.isIncome).toList();

    if (expenses.isEmpty) {
      return const Center(
        child: Text('No expenses yet', style: TextStyle(color: Colors.grey)),
      );
    }

    // Group by category
    final Map<String, double> categoryTotals = {};
    for (var t in expenses) {
      categoryTotals[t.category] = (categoryTotals[t.category] ?? 0) + t.amount;
    }

    // Colors for each category
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.amber,
    ];

    final sections = categoryTotals.entries.toList();

    return Column(
      children: [
        const Text(
          'Spending by Category',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: sections.asMap().entries.map((entry) {
                final index = entry.key;
                final section = entry.value;
                return PieChartSectionData(
                  value: section.value,
                  title: section.key,
                  color: colors[index % colors.length],
                  radius: 80,
                  titleStyle: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Legend
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: sections.asMap().entries.map((entry) {
            final index = entry.key;
            final section = entry.value;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  color: colors[index % colors.length],
                ),
                const SizedBox(width: 4),
                Text(
                  '${section.key}: ₦${section.value.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
