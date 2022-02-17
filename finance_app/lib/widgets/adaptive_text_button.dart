import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveTextButton extends StatelessWidget {
  final VoidCallback onPressedFunction;
  final Widget child;

  const AdaptiveTextButton({
    Key? key,
    required this.onPressedFunction,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: child,
            onPressed: onPressedFunction,
          )
        : TextButton(
            onPressed: onPressedFunction,
            child: child,
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
  }
}
