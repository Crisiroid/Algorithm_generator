// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new
import 'package:algorithm_generator/Screens/algorithm_steps.dart';
import 'package:algorithm_generator/Screens/sollin_algorithm_steps.dart';
import 'package:algorithm_generator/Utils/custom_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  var vertexes = <Map>{};

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.all(7),
                margin: EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.black),
                  color: Color.fromARGB(255, 68, 68, 68),
                  borderRadius: BorderRadius.circular(5),
                ),
                width: MediaQuery.of(context).size.width - 10,
                child: Column(
                  children: [
                    Text(
                      "Choose your desired Algorithm",
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 234, 234),
                          fontSize: 25),
                    ),
                    const SizedBox(height: 15),
                    Builder(builder: (context) {
                      return CustomButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MSTPage(),
                              ),
                            );
                          },
                          text: "Prim");
                    }),
                    Builder(builder: (context) {
                      return CustomButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SollinMstPage(),
                              ),
                            );
                          },
                          text: "Sollin");
                    }),
                    CustomButton(onPressed: () {}, text: "kruskal"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
