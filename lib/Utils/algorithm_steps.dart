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

class MSTPageModified extends StatefulWidget {
  @override
  _MSTPageModifiedState createState() => _MSTPageModifiedState();
}

class _MSTPageModifiedState extends State<MSTPageModified> {
  List<String> nodes = [];
  List<Edge> edges = [];
  List<Edge> mst = [];
  List<String> mstPath = [];
  List<String> tspPath = [];
  int tspDistance = 0;

  final TextEditingController nodesController = TextEditingController();
  final TextEditingController edgesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    calculateMST();
  }

  void calculateMST() {
    final graph = Graph(nodes, edges);
    mst = graph.primMST('S', 'B');
    mstPath = _getPath('S', 'B', mst);
    tspPath = _getTSPPath(mst);
    tspDistance = _calculateTSPDistance(tspPath);
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

  List<String> _getTSPPath(List<Edge> mst) {
    final List<String> path = [];
    for (final edge in mst) {
      path.add(edge.source);
    }
    path.add(mst.last.destination);
    return path;
  }

  int _calculateTSPDistance(List<String> tspPath) {
    int distance = 0;
    for (int i = 0; i < tspPath.length - 1; i++) {
      distance += _findEdgeWeight(tspPath[i], tspPath[i + 1]);
    }
    // Add the edge weight from the last node back to the start node
    distance += _findEdgeWeight(tspPath.last, tspPath.first);
    return distance;
  }

  int _findEdgeWeight(String source, String destination) {
    for (final edge in edges) {
      if (edge.source == source && edge.destination == destination) {
        return edge.weight;
      }
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minimum Spanning Tree (Prim) and TSP'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter Nodes:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: nodesController,
                decoration: const InputDecoration(
                  hintText:
                      'Enter nodes separated by commas (e.g., S, A, B, C)',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Enter Edges:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: edgesController,
                decoration: const InputDecoration(
                  hintText:
                      'Enter edges in the format: source, destination, weight\nSeparate multiple edges by commas',
                ),
                maxLines: null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    nodes = nodesController.text
                        .split(',')
                        .map((node) => node.trim())
                        .toList();
                    final List<String> edgeList =
                        edgesController.text.split(',');
                    edges = [];
                    for (int i = 0; i < edgeList.length; i += 3) {
                      final String source = edgeList[i].trim();
                      final String destination = edgeList[i + 1].trim();
                      final int weight =
                          int.tryParse(edgeList[i + 2].trim()) ?? 0;
                      edges.add(Edge(source, destination, weight));
                    }
                    calculateMST();
                  });
                },
                child: const Text('Calculate MST'),
              ),
              const SizedBox(height: 16),
              if (mstPath.isNotEmpty) ...[
                const Text(
                  'Minimum Spanning Tree (Prim):',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: mst.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: ListTile(
                        title: Text(
                            '${mst[index].source} - ${mst[index].destination}'),
                        subtitle: Text('Weight: ${mst[index].weight}'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'MST Path:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(mstPath.join(' -> ')),
                const SizedBox(height: 16),
                const Text(
                  'TSP Path:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(tspPath.join(' -> ')),
                const SizedBox(height: 16),
                const Text(
                  'TSP Distance:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(tspDistance.toString()),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
