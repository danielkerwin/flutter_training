import 'package:flutter/material.dart';
import 'package:flutter_guide_finance/widgets/adaptive_expanded_button.dart';
import 'package:flutter_guide_finance/widgets/adaptive_text_button.dart';
import 'package:flutter_guide_finance/widgets/adaptive_text_field.dart';
import 'package:intl/intl.dart';

import '/models/transaction.dart';

class NewTransaction extends StatefulWidget {
  final AddNewTransactionCallback addNewTransaction;

  NewTransaction({Key? key, required this.addNewTransaction})
      : super(key: key) {
    print('constructor() NewTransaction');
  }

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    print('initState() NewTransaction');
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    print('setState() NewTransaction');
  }

  @override
  void didUpdateWidget(covariant NewTransaction oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget() NewTransaction');
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose() NewTransaction');
  }

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.tryParse(_amountController.text);

    if (enteredTitle.isEmpty ||
        enteredAmount == null ||
        enteredAmount <= 0 ||
        _selectedDate == null) {
      return;
    }

    widget.addNewTransaction(
      enteredTitle,
      enteredAmount,
      _selectedDate as DateTime,
    );

    Navigator.of(context).pop();
  }

  void _showDatePicker() async {
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime.now());

    if (pickedDate == null) {
      return;
    }
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build() NewTransaction');
    return SingleChildScrollView(
      child: Card(
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AdaptiveTextField(
                placeholder: 'Title',
                controller: _titleController,
                onSubmittedFunction: _submitData,
              ),
              AdaptiveTextField(
                placeholder: 'Amount',
                controller: _amountController,
                onSubmittedFunction: _submitData,
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'No Date Chosen!'
                          : DateFormat.yMMMMd()
                              .format(_selectedDate as DateTime)),
                    ),
                    AdaptiveTextButton(
                      onPressedFunction: _showDatePicker,
                      child: const Text('Select Date'),
                    ),
                  ],
                ),
              ),
              AdaptiveExpandedButton(
                onPressedFunction: _submitData,
                child: const Text('Add Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
