import 'package:flutter/material.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minimum Spanning Tree (Kruskal\'s Algorithm)'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [
                Text(
                  'Kruskal\'s Algorithm:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Kruskal\'s algorithm is a greedy algorithm that finds a minimum spanning tree for a connected weighted graph. It starts with an empty graph and gradually adds edges with the smallest weights until all the nodes are connected. At each step, it considers the smallest available edge that does not form a cycle with the existing edges in the graph. Kruskal\'s algorithm is efficient and guarantees to find the minimum spanning tree.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
