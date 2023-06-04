import 'package:flutter/material.dart';

class Edge {
  final String source;
  final String destination;
  final int weight;

  Edge(this.source, this.destination, this.weight);
}

class Graph {
  final List<String> nodes;
  final Map<String, List<Edge>> adjacencyList;

  Graph(this.nodes) : adjacencyList = {for (var node in nodes) node: []};

  void addEdge(String source, String destination, int weight) {
    final edge1 = Edge(source, destination, weight);
    final edge2 = Edge(destination, source, weight);
    adjacencyList[source]!.add(edge1);
    adjacencyList[destination]!.add(edge2);
  }

  List<Edge> primMST() {
    final List<bool> visited = List<bool>.filled(nodes.length, false);
    final List<Edge> mst = [];
    final List<int> key = List<int>.filled(nodes.length, 999999);
    final List<String> parent = List<String>.filled(nodes.length, '');

    key[0] = 0; // Start with the first node

    for (int count = 0; count < nodes.length - 1; count++) {
      final u = _minKey(key, visited);
      visited[u] = true;

      for (final edge in adjacencyList[nodes[u]]!) {
        final v = nodes.indexOf(edge.destination);

        if (!visited[v] && edge.weight < key[v]) {
          parent[v] = nodes[u];
          key[v] = edge.weight;
        }
      }
    }

    for (int i = 1; i < nodes.length; i++) {
      mst.add(Edge(parent[i], nodes[i], key[i]));
    }

    return mst;
  }

  int _minKey(List<int> key, List<bool> visited) {
    int min = 999999;
    int minIndex = -1;

    for (int v = 0; v < nodes.length; v++) {
      if (!visited[v] && key[v] < min) {
        min = key[v];
        minIndex = v;
      }
    }

    return minIndex;
  }
}

class MSTPage extends StatefulWidget {
  @override
  _MSTPageState createState() => _MSTPageState();
}

class _MSTPageState extends State<MSTPage> {
  final List<String> nodes = ['S', 'A', 'B', 'C', 'D', 'T'];
  final Graph graph = Graph(['S', 'A', 'B', 'C', 'D', 'T']);
  List<Edge> mst = [];

  @override
  void initState() {
    super.initState();
    // Add edges to the graph
    graph.addEdge('S', 'A', 7);
    graph.addEdge('S', 'C', 8);
    graph.addEdge('A', 'C', 3);
    graph.addEdge('A', 'B', 6);
    graph.addEdge('A', 'D', 3);
    graph.addEdge('B', 'T', 5);
    graph.addEdge('C', 'C', 2);
    graph.addEdge('C', 'B', 4);
    graph.addEdge('D', 'T', 2);

    // Calculate the Minimum Spanning Tree
    mst = graph.primMST();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minimum Spanning Tree'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              'Steps:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: mst.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    '${mst[index].source} - ${mst[index].destination} : ${mst[index].weight}',
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              'Final MST:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: mst.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    '${mst[index].source} - ${mst[index].destination} : ${mst[index].weight}',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
