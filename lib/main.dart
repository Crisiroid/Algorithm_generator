import 'package:algorithm_generator/Screens/home_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(mainApp());

class mainApp extends StatelessWidget {
  const mainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}
