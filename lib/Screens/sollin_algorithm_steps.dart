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

  List<Edge> sollinMST() {
    final List<List<String>> forest =
        List<List<String>>.generate(nodes.length, (index) => [nodes[index]]);

    final List<Edge> mst = [];
    final List<Edge> sortedEdges = List<Edge>.from(edges)..sort(_compareEdges);

    while (mst.length < nodes.length - 1) {
      final List<Edge> safeEdges = [];

      for (final edge in sortedEdges) {
        final String sourceRoot = _findRoot(forest, edge.source);
        final String destRoot = _findRoot(forest, edge.destination);

        if (sourceRoot != destRoot) {
          safeEdges.add(edge);
          _union(forest, sourceRoot, destRoot);

          if (safeEdges.length == nodes.length - 1) {
            break;
          }
        }
      }

      mst.addAll(safeEdges);
    }

    return mst;
  }

  int _compareEdges(Edge a, Edge b) {
    return a.weight.compareTo(b.weight);
  }

  String _findRoot(List<List<String>> forest, String node) {
    for (final tree in forest) {
      if (tree.contains(node)) {
        return tree[0];
      }
    }

    return '';
  }

  void _union(List<List<String>> forest, String root1, String root2) {
    final int index1 = _findRootIndex(forest, root1);
    final int index2 = _findRootIndex(forest, root2);

    if (index1 != -1 && index2 != -1 && index1 != index2) {
      forest[index1].addAll(forest[index2]);
      forest.removeAt(index2);
    }
  }

  int _findRootIndex(List<List<String>> forest, String root) {
    for (int i = 0; i < forest.length; i++) {
      if (forest[i][0] == root) {
        return i;
      }
    }

    return -1;
  }
}

class SollinMstPage extends StatefulWidget {
  @override
  _SolinMstPageState createState() => _SolinMstPageState();
}

class _SolinMstPageState extends State<SollinMstPage> {
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

  @override
  void initState() {
    super.initState();
    // Calculate the Minimum Spanning Tree
    final graph = Graph(nodes, edges);
    mst = graph.sollinMST();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minimum Spanning Tree'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Sollin\'s Algorithm:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Sollin\'s algorithm is a parallel algorithm for finding the Minimum Spanning Tree (MST) of a graph. It is based on the concept of a forest of trees, where each tree represents a connected component of the graph. The algorithm iteratively merges the trees in the forest by adding safe edges, which are the lightest edges connecting two different trees. The process continues until the forest is reduced to a single tree, which represents the MST of the graph.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
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
        ],
      ),
    );
  }
}
