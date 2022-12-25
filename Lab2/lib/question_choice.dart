import 'package:flutter/material.dart';

class QuestionChoice extends StatelessWidget {
  final String _choiceText;
  final VoidCallback _callBack;
  const QuestionChoice(this._callBack, this._choiceText);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(18.0),
        child:SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
                textStyle: MaterialStateProperty.all(const TextStyle(
                  color: Colors.white,
                ))),
            onPressed: _callBack,
            child: Text(_choiceText),
          ),
    ));
  }
}
