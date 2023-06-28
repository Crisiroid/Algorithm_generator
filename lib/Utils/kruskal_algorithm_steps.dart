import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Edge {
  final String source;
  final String destination;
  final int weight;

  Edge({required this.source, required this.destination, required this.weight});
}

class Graph {
  final List<String> nodes;
  final List<Edge> edges;

  Graph({required this.nodes, required this.edges});

  List<Edge> kruskalMST(String startNode, String endNode) {
    edges.sort((a, b) => a.weight.compareTo(b.weight));
    final Map<String, String> parentMap = {};
    final List<Edge> mst = [];

    for (final node in nodes) {
      parentMap[node] = node;
    }

    String findParent(String node) {
      if (parentMap[node] != node) {
        parentMap[node] = findParent(parentMap[node]!);
      }
      return parentMap[node]!;
    }

    void union(String node1, String node2) {
      final parent1 = findParent(node1);
      final parent2 = findParent(node2);
      parentMap[parent2] = parent1;
    }

    int numEdges = 0;
    int index = 0;

    while (numEdges < nodes.length - 1) {
      final Edge currentEdge = edges[index];
      final String sourceParent = findParent(currentEdge.source);
      final String destParent = findParent(currentEdge.destination);

      if (sourceParent != destParent) {
        mst.add(currentEdge);
        union(sourceParent, destParent);
        numEdges++;
      }

      index++;
    }

    return mst;
  }

  List<String> getPath(String startNode, String endNode, List<Edge> mst) {
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

  int calculateTSPDistance(List<String> path) {
    int distance = 0;

    for (int i = 0; i < path.length - 1; i++) {
      final String source = path[i];
      final String destination = path[i + 1];

      for (final edge in edges) {
        if ((edge.source == source && edge.destination == destination) ||
            (edge.source == destination && edge.destination == source)) {
          distance += edge.weight;
          break;
        }
      }
    }

    return distance;
  }

  List<String> calculateTSPSteps(List<String> path) {
    final List<String> steps = [];
    int distance = 0;

    for (int i = 0; i < path.length - 1; i++) {
      final String source = path[i];
      final String destination = path[i + 1];

      for (final edge in edges) {
        if ((edge.source == source && edge.destination == destination) ||
            (edge.source == destination && edge.destination == source)) {
          distance += edge.weight;
          steps.add('$source -> $destination (Weight: ${edge.weight})');
          break;
        }
      }
    }

    steps.add('Total Distance: $distance');
    return steps;
  }

  List<List<int>> createDistanceTable(List<String> path) {
    final int numNodes = path.length;
    final List<List<int>> table = List<List<int>>.generate(
      numNodes,
      (_) => List<int>.filled(numNodes, 0),
    );

    for (int i = 0; i < numNodes; i++) {
      for (int j = i + 1; j < numNodes; j++) {
        final String source = path[i];
        final String destination = path[j];

        for (final edge in edges) {
          if ((edge.source == source && edge.destination == destination) ||
              (edge.source == destination && edge.destination == source)) {
            table[i][j] = edge.weight;
            table[j][i] = edge.weight;
            break;
          }
        }
      }
    }

    return table;
  }
}

class KruskalMSTScreen extends StatelessWidget {
  final Graph graph = Graph(
    nodes: ['S', 'A', 'C', 'B', 'T', 'D'],
    edges: [
      Edge(source: 'S', destination: 'A', weight: 7),
      Edge(source: 'S', destination: 'C', weight: 8),
      Edge(source: 'A', destination: 'C', weight: 3),
      Edge(source: 'C', destination: 'C', weight: 2),
      Edge(source: 'A', destination: 'B', weight: 6),
      Edge(source: 'A', destination: 'B', weight: 9),
      Edge(source: 'B', destination: 'T', weight: 5),
      Edge(source: 'C', destination: 'B', weight: 4),
      Edge(source: 'A', destination: 'D', weight: 3),
      Edge(source: 'D', destination: 'T', weight: 2),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final List<Edge> mst = graph.kruskalMST('S', 'B');
    final List<String> path = graph.getPath('S', 'B', mst);
    final List<String> tspSteps = graph.calculateTSPSteps(path);
    final List<List<int>> distanceTable = graph.createDistanceTable(path);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Travelling Salesman Problem (TSP)'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: mst.length,
              itemBuilder: (context, index) {
                final edge = mst[index];
                return Card(
                  elevation: 2,
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    title: Text('${edge.source} - ${edge.destination}'),
                    subtitle: Text('Weight: ${edge.weight}'),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'MST Path:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  path.join(' -> '),
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'TSP Steps:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Column(
                  children: tspSteps
                      .map(
                        (step) => Text(
                          step,
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Distance Table:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Table(
                  border: TableBorder.all(),
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: const Text(
                              'Node',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        ...path.map((node) {
                          return TableCell(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                node,
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                    ...distanceTable.asMap().entries.map((entry) {
                      final int rowIndex = entry.key;
                      final List<int> row = entry.value;
                      final String node = path[rowIndex];

                      return TableRow(
                        children: [
                          TableCell(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                node,
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          ...row.map((distance) {
                            return TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  distance.toString(),
                                  style: const TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
