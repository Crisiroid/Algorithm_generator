import 'package:flutter/material.dart';

class ShowSteps extends StatelessWidget {
  final String algorithmName;
  final List<String> steps;
  final String result;
  const ShowSteps(
      {super.key,
      required this.algorithmName,
      required this.steps,
      required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [Text(algorithmName + "'s Steps")]),
    );
  }
}
