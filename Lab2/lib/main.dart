import 'package:flutter/material.dart';
import 'package:lab2/model/clothing_question_model.dart';

import './clothing_question.dart';
import './question_choice.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  void iWasTapped() => print('I was tapped');
  var questions = [
    ClothingQuestionModel("Sezona: ", ["Zima", "Prolet", "Leto", "Esen"]),
    ClothingQuestionModel("Tip: ", ["Dolna", "Gorna", "Obuvki", "Akssoari"]),
    ClothingQuestionModel("Materijal: ", ["Pamuk", "Volna", "Poliester", "Svila"])
  ];
  var _questionIndex = 0;
  void _answerQuestion() {
    setState(() {
      if (_questionIndex < questions.length - 1) {
        _questionIndex += 1;
      } else {
        _questionIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hallo World",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Hallo World"),
        ),
        body: Column(
          children: [
            ClothingQuestion(questions[_questionIndex].question),
            ...(questions[_questionIndex].answers).map((answer) {
              return QuestionChoice(
                _answerQuestion,
                answer,
              );
            })
          ],
        ),
      ),
    );
  }
}
