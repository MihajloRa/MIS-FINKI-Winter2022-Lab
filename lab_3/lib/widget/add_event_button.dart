import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddEventButton extends StatelessWidget {
  final String text;
  final VoidCallback handler;

  const AddEventButton(this.text, this.handler);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
      onPressed: handler,
      child: Text(text)
    )
        : TextButton(
      onPressed: handler,
      child: Text(text),
    );
  }
}
