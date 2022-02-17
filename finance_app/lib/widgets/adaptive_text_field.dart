import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveTextField extends StatelessWidget {
  final String placeholder;
  final TextEditingController controller;
  final VoidCallback onSubmittedFunction;
  const AdaptiveTextField({
    Key? key,
    required this.placeholder,
    required this.controller,
    required this.onSubmittedFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoTextField(
            placeholder: placeholder,
            style: Theme.of(context).textTheme.bodyLarge,
            keyboardType: TextInputType.text,
            controller: controller,
            onSubmitted: (_) => onSubmittedFunction(),
          )
        : TextField(
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: InputDecoration(labelText: placeholder),
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onSubmitted: (_) => onSubmittedFunction(),
          );
  }
}
