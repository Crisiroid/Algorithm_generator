import 'package:flutter/material.dart';

class Edge {
  final String source;
  final String destination;
  final int weight;

  Edge(this.source, this.destination, this.weight);
}

class Graph {
  final List<String> nodes;
  final List<Edge> edges;

  Graph(this.nodes, this.edges);

  List<Edge> primMST(String startNode, String endNode) {
    final Map<String, int> keyMap = {};
    final Map<String, String> parentMap = {};
    final Set<String> visitedNodes = {};

    for (final node in nodes) {
      keyMap[node] = 999999;
    }

    keyMap[startNode] = 0;

    while (visitedNodes.length != nodes.length) {
      final String currentNode = _getMinKey(keyMap, visitedNodes);
      visitedNodes.add(currentNode);

      for (final edge in edges) {
        if (edge.source == currentNode &&
            !visitedNodes.contains(edge.destination) &&
            edge.weight < keyMap[edge.destination]!) {
          keyMap[edge.destination] = edge.weight;
          parentMap[edge.destination] = edge.source;
        }
      }
    }

    final List<Edge> mst = [];
    String node = endNode;

    while (node != startNode) {
      final String parent = parentMap[node]!;
      final int weight = _findEdgeWeight(parent, node);
      mst.add(Edge(parent, node, weight));
      node = parent;
    }

    return mst.reversed.toList();
  }

  String _getMinKey(Map<String, int> keyMap, Set<String> visitedNodes) {
    int min = 999999999;
    String minKey = '';

    for (final entry in keyMap.entries) {
      if (!visitedNodes.contains(entry.key) && entry.value < min) {
        min = entry.value;
        minKey = entry.key;
      }
    }

    return minKey;
  }

  int _findEdgeWeight(String source, String destination) {
    for (final edge in edges) {
      if (edge.source == source && edge.destination == destination) {
        return edge.weight;
      }
    }

    return 0;
  }
}

class MSTPage extends StatefulWidget {
  @override
  _MSTPageState createState() => _MSTPageState();
}

class _MSTPageState extends State<MSTPage> {
  final List<String> nodes = ['S', 'A', 'B', 'C', 'D', 'T'];
  final List<Edge> edges = [
    Edge('S', 'A', 7),
    Edge('S', 'C', 8),
    Edge('A', 'C', 3),
    Edge('A', 'B', 6),
    Edge('A', 'D', 3),
    Edge('B', 'T', 5),
    Edge('C', 'C', 2),
    Edge('C', 'B', 4),
    Edge('D', 'T', 2),
  ];
  List<Edge> mst = [];
  List<String> path = [];

  @override
  void initState() {
    super.initState();
    final graph = Graph(nodes, edges);
    mst = graph.primMST('S', 'B');
    path = _getPath('S', 'B', mst);
  }

  List<String> _getPath(String startNode, String endNode, List<Edge> mst) {
    final List<String> path = [startNode];
    String currentNode = startNode;

    while (currentNode != endNode) {
      for (final edge in mst) {
        if (edge.source == currentNode) {
          path.add(edge.destination);
          currentNode = edge.destination;
          break;
        }
      }
    }

    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minimum Spanning Tree (Prim)'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Prim\'s Algorithm:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Prim\'s algorithm is a greedy algorithm that finds the Minimum Spanning Tree (MST) of a connected, weighted graph. It starts with an arbitrary node and repeatedly adds the edge with the minimum weight that connects a node in the MST to a node outside the MST, until all nodes are included in the MST. The algorithm maintains a set of visited nodes and a priority queue (min-heap) of edges.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Steps:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: mst.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    title: Text(
                        '${mst[index].source} - ${mst[index].destination}'),
                    subtitle: Text('Weight: ${mst[index].weight}'),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'MST Path (S to B):',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              path.join(' -> '),
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
