import 'package:algorithm_generator/Utils/algorithm_steps.dart';
import 'package:algorithm_generator/Utils/kruskal_algorithm_steps.dart';
import 'package:algorithm_generator/Utils/custom_button.dart';
import 'package:flutter/material.dart';

class Edge {
  final String startNode;
  final String endNode;
  final String weight;

  Edge(this.startNode, this.endNode, this.weight);
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String startNode = '';

  String endNode = '';

  String weight = '';

  List<Edge> edges = [];

  bool isElementsVisible = true;

  @override
  void initState() {
    super.initState();
    // Add default edges to the graph
    edges.add(Edge('S', 'A', '7'));
    edges.add(Edge('S', 'C', '8'));
    edges.add(Edge('A', 'C', '3'));
    edges.add(Edge('A', 'B', '9'));
    edges.add(Edge('A', 'B', '6'));
    edges.add(Edge('C', 'D', '3'));
    edges.add(Edge('B', 'T', '5'));
    edges.add(Edge('B', 'D', '2'));
    edges.add(Edge('C', 'C', '2'));
    edges.add(Edge('C', 'B', '4'));
    edges.add(Edge('D', 'T', '2'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Graph Input'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SwitchListTile(
                title: Text('Show Elements'),
                value: isElementsVisible,
                onChanged: (value) {
                  setState(() {
                    isElementsVisible = value;
                  });
                },
              ),
              if (isElementsVisible) ...[
                SizedBox(height: 16.0),
                TextField(
                  decoration: InputDecoration(labelText: 'Starting Node'),
                  onChanged: (value) {
                    setState(() {
                      startNode = value;
                    });
                  },
                ),
                SizedBox(height: 8.0),
                TextField(
                  decoration: InputDecoration(labelText: 'Ending Node'),
                  onChanged: (value) {
                    setState(() {
                      endNode = value;
                    });
                  },
                ),
                SizedBox(height: 8.0),
                TextField(
                  decoration: InputDecoration(labelText: 'Weight'),
                  onChanged: (value) {
                    setState(() {
                      weight = value;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  child: Text('Add Edge'),
                  onPressed: () {
                    setState(() {
                      edges.add(Edge(startNode, endNode, weight));
                    });
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  child: Text('Print Graph'),
                  onPressed: () {
                    printGraph();
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  child: Text('Clear Edges'),
                  onPressed: () {
                    setState(() {
                      edges.clear();
                    });
                  },
                ),
              ],
              CustomButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MSTPageModified(),
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

  bool checkNodesExist(String startNode, String endNode) {
    bool startNodeExists = edges.any((edge) => edge.startNode == startNode);
    bool endNodeExists = edges.any((edge) => edge.startNode == endNode);
    return startNodeExists && endNodeExists;
  }

  void printGraph() {
    print('Graph:');
    edges.forEach((edge) {
      print('${edge.startNode} -> ${edge.endNode} : ${edge.weight}');
    });
  }
}
