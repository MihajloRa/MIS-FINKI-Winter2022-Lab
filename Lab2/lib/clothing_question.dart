import 'package:flutter/material.dart';

class ClothingQuestion extends StatelessWidget {
  final String _questionText;

  ClothingQuestion(this._questionText);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      child: Text(
        _questionText,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30, color: Colors.red),
      ),
    );
  }
}
