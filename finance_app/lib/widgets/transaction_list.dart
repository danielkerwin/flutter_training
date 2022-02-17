import 'package:flutter/material.dart';
import 'package:flutter_guide_finance/widgets/transaction_item.dart';
import '/models/transaction.dart';

class Transactionlist extends StatelessWidget {
  final List<Transaction> userTransactions;
  final DeleteTransactionCallback deleteTransaction;
  final double mediaWidth;

  const Transactionlist({
    Key? key,
    required this.userTransactions,
    required this.deleteTransaction,
    required this.mediaWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('build() TransactionList');
    return userTransactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                Text(
                  'No transactions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (ctx, idx) {
              return TransactionItem(
                key: ValueKey(userTransactions[idx].id),
                transaction: userTransactions[idx],
                mediaWidth: mediaWidth,
                deleteTransaction: deleteTransaction,
              );
            },
            itemCount: userTransactions.length,
          );
  }
}
