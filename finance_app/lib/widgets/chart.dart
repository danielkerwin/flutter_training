import 'package:flutter/material.dart';
import '/widgets/chart_bar.dart';
import '/models/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  const Chart({Key? key, required this.recentTransactions}) : super(key: key);

  double get totalTransactionValue {
    return recentTransactions.fold(0.0, (value, tx) => value + tx.amount);
  }

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (idx) {
      final weekday = DateTime.now().subtract(
        Duration(days: idx),
      );

      double totalSum = 0;
      for (var tx in recentTransactions) {
        if (tx.date.day == weekday.day &&
            tx.date.month == weekday.month &&
            tx.date.year == weekday.year) {
          totalSum += tx.amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekday).substring(0, 1),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    print('build() Chart');
    final total = totalTransactionValue;
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                key: Key(data['day'] as String),
                label: data['day'] as String,
                spendingAmount: data['amount'] as double,
                spendingPctOfTotal:
                    total == 0.0 ? 0.0 : (data['amount'] as double) / total,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
