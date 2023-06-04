// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new

import 'package:algorithm_generator/Utils/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var graph = new Graph();
  FruchtermanReingoldAlgorithm builder = FruchtermanReingoldAlgorithm();
  @override
  void initState() {
    final node = Node.Id(0);
    final node1 = Node.Id(1);
    final node2 = Node.Id(2);
    final node3 = Node.Id(3);
    final node4 = Node.Id(4);
    final node5 = Node.Id(5);
    graph.addEdge(node, node1);
    graph.addEdge(node, node3);
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: InteractiveViewer(
                constrained: true,
                minScale: 0.01,
                maxScale: 1,
                child: GraphView(
                  graph: graph,
                  algorithm: FruchtermanReingoldAlgorithm(),
                  builder: (Node node) {
                    var a = node.key?.value as int;
                    return rectangleWidget(a);
                  },
                ),
              ),
            ),
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
                    CustomButton(onPressed: () {}, text: "Prim"),
                    CustomButton(onPressed: () {}, text: "Sollin"),
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

Widget rectangleWidget(int a) {
  return InkWell(
    onTap: () {
      print('clicked');
    },
    child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(color: Color.fromARGB(255, 46, 67, 84), spreadRadius: 1),
          ],
        ),
        child: Text('Node ${a}')),
  );
}
