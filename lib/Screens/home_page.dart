import 'package:algorithm_generator/Screens/algorithm_steps.dart';
import 'package:algorithm_generator/Screens/kruskal_algorithm_steps.dart';
import 'package:algorithm_generator/Screens/sollin_algorithm_steps.dart';
import 'package:algorithm_generator/Utils/custom_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Choose Your Desired Algorithm',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MSTPage(),
                    ),
                  );
                },
                text: 'Prim',
              ),
              const SizedBox(height: 20),
              CustomButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SollinMstPage(),
                    ),
                  );
                },
                text: 'Sollin',
              ),
              const SizedBox(height: 20),
              CustomButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KruskalMSTScreen(),
                    ),
                  );
                },
                text: 'Kruskal',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
