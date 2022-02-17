import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveExpandedButton extends StatelessWidget {
  final VoidCallback onPressedFunction;
  final Widget child;

  const AdaptiveExpandedButton({
    Key? key,
    required this.onPressedFunction,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: child,
            color: Theme.of(context).colorScheme.primary,
            onPressed: onPressedFunction,
          )
        : ElevatedButton(
            onPressed: onPressedFunction,
            child: child,
          );
  }
}
