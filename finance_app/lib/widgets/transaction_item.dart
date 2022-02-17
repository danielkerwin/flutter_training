import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/models/transaction.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final double mediaWidth;
  final DeleteTransactionCallback deleteTransaction;

  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.mediaWidth,
    required this.deleteTransaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10,
      ),
      child: ListTile(
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(transaction.date),
        ),
        leading: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(
              child: Text(
                '\$${transaction.amount}',
                style: Theme.of(context).primaryTextTheme.bodyMedium,
              ),
            ),
          ),
        ),
        trailing: mediaWidth > 400
            ? TextButton.icon(
                label: const Text('Delete'),
                icon: const Icon(Icons.delete),
                onPressed: () => deleteTransaction(transaction.id),
              )
            : IconButton(
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => deleteTransaction(transaction.id),
              ),
      ),
    );
  }
}
