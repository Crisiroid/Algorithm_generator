import 'package:flutter/material.dart';
import 'get_user_input.dart';

class KruskalAlgo extends StatelessWidget {
  final List<Edge> edges;
  final String startingNode;
  final String endingNode;

  KruskalAlgo({
    required this.edges,
    required this.startingNode,
    required this.endingNode,
  });

  @override
  Widget build(BuildContext context) {
    final mst = kruskalAlgorithm(edges, startingNode, endingNode);
    List<String> mstPath =
        mst.map((edge) => '${edge.startNode} -> ${edge.endNode}').toList();
    String fullMstPath = mstPath.join(', ');

    final tsp = tspAlgorithm(mst, startingNode, endingNode);
    List<String> tspPath =
        tsp.map((edge) => '${edge.startNode} -> ${edge.endNode}').toList();
    String fullTspPath = tspPath.join(' -> ');

    List<TableRow> tspTableRows = buildTSPTable(mst, tspPath);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kruskal Algorithm'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Graph Edges:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Expanded(child: GraphView(edges: edges)),
            const SizedBox(height: 32),
            const Text(
              'Minimum Spanning Tree (MST):',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(child: GraphView(edges: mst)),
            const SizedBox(height: 32),
            const Text(
              'TSP Path:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8.0),
            Text(
              fullTspPath,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'MST Path:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8.0),
            Text(
              fullMstPath,
              style: const TextStyle(fontSize: 16),
            ),
            const Text(
              'TSP Table:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8.0),
            Table(
              border: TableBorder.all(),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: tspTableRows,
            ),
          ],
        ),
      ),
    );
  }
}

class GraphView extends StatelessWidget {
  final List<Edge> edges;

  GraphView({required this.edges});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Customize the container size and style according to your needs
      height: 300,
      child: ListView.builder(
        itemCount: edges.length,
        itemBuilder: (context, index) {
          final edge = edges[index];
          return ListTile(
            title: Text('${edge.startNode} -> ${edge.endNode}'),
            subtitle: Text('Weight: ${edge.weight}'),
          );
        },
      ),
    );
  }
}

List<Edge> kruskalAlgorithm(
    List<Edge> edges, String startingNode, String endingNode) {
  edges.sort((a, b) => int.parse(a.weight).compareTo(int.parse(b.weight)));

  final parent = <String, String>{};
  final mst = <Edge>[];

  for (var edge in edges) {
    parent[edge.startNode] ??= edge.startNode;
    parent[edge.endNode] ??= edge.endNode;
  }

  String find(String vertex) {
    if (parent[vertex] != vertex) {
      parent[vertex] = find(parent[vertex]!);
    }
    return parent[vertex]!;
  }

  void union(String vertex1, String vertex2) {
    parent[find(vertex1)] = find(vertex2);
  }

  int count = 0; // Counter to track the number of edges in MST

  for (var edge in edges) {
    final startNodeParent = find(edge.startNode);
    final endNodeParent = find(edge.endNode);

    if (startNodeParent != endNodeParent) {
      mst.add(edge);
      union(startNodeParent, endNodeParent);
      count++;

      if (count == edges.length - 1) {
        // All vertices are connected in the MST
        break;
      }
    }
  }

  // Filter the MST path to start from startingNode and end at endingNode
  final filteredPath = <Edge>[];
  String currentNode = startingNode;

  while (currentNode != endingNode) {
    for (var edge in mst) {
      if (edge.startNode == currentNode) {
        filteredPath.add(edge);
        currentNode = edge.endNode;
        break;
      }
    }
  }

  return filteredPath;
}

List<Edge> tspAlgorithm(
    List<Edge> mst, String startingNode, String endingNode) {
  final visited = <String>{};
  final tspPath = <Edge>[];
  visited.add(endingNode);

  // Depth-first search to find the TSP path
  void dfs(String node) {
    if (node == startingNode) {
      return;
    }

    for (var edge in mst) {
      if (edge.endNode == node && !visited.contains(edge.startNode)) {
        tspPath.add(edge);
        visited.add(edge.startNode);
        dfs(edge.startNode);
        return;
      }
      if (edge.startNode == node && !visited.contains(edge.endNode)) {
        tspPath.add(edge);
        visited.add(edge.endNode);
        dfs(edge.endNode);
        return;
      }
    }
  }

  dfs(endingNode);

  return tspPath.reversed.toList();
}

List<TableRow> buildTSPTable(List<Edge> mst, List<String> tspPath) {
  List<TableRow> rows = [];

  rows.add(
    const TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Step'),
          ),
        ),
        TableCell(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Current Node'),
          ),
        ),
        TableCell(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Next Node'),
          ),
        ),
      ],
    ),
  );

  for (int i = 0; i < tspPath.length - 1; i++) {
    String currentNode = tspPath[i];
    String nextNode = tspPath[i + 1];

    bool isMSTEdge = mst.any((edge) =>
        (edge.startNode == currentNode && edge.endNode == nextNode) ||
        (edge.startNode == nextNode && edge.endNode == currentNode));

    rows.add(
      TableRow(
        children: [
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text((i + 1).toString()),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(currentNode),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(nextNode),
            ),
          ),
        ],
        decoration: isMSTEdge ? const BoxDecoration(color: Colors.green) : null,
      ),
    );
  }

  return rows;
}
