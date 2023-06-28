// ignore_for_file: camel_case_types

import 'package:algorithm_generator/Utils/home_page.dart';

import 'Screens/get_user_input.dart';
import 'package:flutter/material.dart';

void main() => runApp(mainApp());

class mainApp extends StatelessWidget {
  const mainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: GraphPage(),
    );
  }
}
