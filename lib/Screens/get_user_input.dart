import 'package:flutter/material.dart';
import 'PrimsAlgo.dart';
import 'KruskalAlgo.dart';
import 'package:flutter/cupertino.dart'; // Import Cupertino-style alerts

class GraphPage extends StatefulWidget {
  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
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
    edges.add(Edge('D', 'B', '2'));
    edges.add(Edge('C', 'C', '2'));
    edges.add(Edge('C', 'B', '4'));
    edges.add(Edge('D', 'T', '2'));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(), // Apply dark theme
      home: Scaffold(
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
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey[800], // Set dark background color
                    ),
                    child: Text('Add Edge'),
                    onPressed: () {
                      setState(() {
                        edges.add(Edge(startNode, endNode, weight));
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey[800], // Set dark background color
                    ),
                    child: Text('Print Graph'),
                    onPressed: () {
                      printGraph();
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey[800], // Set dark background color
                    ),
                    child: Text('Clear Edges'),
                    onPressed: () {
                      setState(() {
                        edges.clear();
                      });
                    },
                  ),
                ],
                SizedBox(height: 32.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[800], // Set dark background color
                  ),
                  child: Text('Prim'),
                  onPressed: () {
                    showAlgorithmAlert('Prim');
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[800], // Set dark background color
                  ),
                  child: Text('Kruskal'),
                  onPressed: () {
                    showAlgorithmAlert('Kruskal');
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Created by Crisiroid',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12.0,
            ),
          ),
        ),
      ),
    );
  }

  void printGraph() {
    print('Graph:');
    edges.forEach((edge) {
      print('${edge.startNode} -> ${edge.endNode} : ${edge.weight}');
    });
  }

  void showAlgorithmAlert(String algorithm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Starting and Ending Nodes'),
          content: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Starting Node'),
                onChanged: (value) {
                  setState(() {
                    startNode = value;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Ending Node'),
                onChanged: (value) {
                  setState(() {
                    endNode = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Run'),
              onPressed: () {
                if (checkNodesExist(startNode, endNode)) {
                  Navigator.pop(context);
                  if (algorithm == 'Prim') {
                    runPrimAlgorithm(startNode, endNode);
                  } else if (algorithm == 'Kruskal') {
                    runKruskalAlgorithm(startNode, endNode);
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content:
                            Text('Starting or Ending Node does not exist.'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  bool checkNodesExist(String startNode, String endNode) {
    bool startNodeExists = edges.any((edge) => edge.startNode == startNode);
    bool endNodeExists = edges.any((edge) => edge.startNode == endNode);
    return startNodeExists && endNodeExists;
  }

  void runPrimAlgorithm(String startNode, String endNode) {
    print(startNode + " " + endNode);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrimsAlgo(
          edges: edges,
          startingNode: startNode,
          endingNode: endNode,
        ),
      ),
    );
  }

  void runKruskalAlgorithm(String startNode, String endNode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KruskalAlgo(
          edges: edges,
          startingNode: startNode,
          endingNode: endNode,
        ),
      ),
    );
  }
}

class Edge {
  final String startNode;
  final String endNode;
  final String weight;

  Edge(this.startNode, this.endNode, this.weight);
}
