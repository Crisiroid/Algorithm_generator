import 'package:flutter/material.dart';
import 'get_user_input.dart';

class PrimsAlgo extends StatelessWidget {
  final List<Edge> edges;
  final String startingNode;
  final String endingNode;

  PrimsAlgo({
    required this.edges,
    required this.startingNode,
    required this.endingNode,
  });

  @override
  Widget build(BuildContext context) {
    List<Edge> mst = primAlgorithm(edges, startingNode, endingNode);
    List<String> mstPath =
        mst.map((edge) => '${edge.startNode} -> ${edge.endNode}').toList();
    String fullMstPath = mstPath.join(', ');

    int totalWeight = mst.fold(0, (sum, edge) => sum + int.parse(edge.weight));
    String mstWeightText = 'Total Weight: $totalWeight';

    List<String> tspPath = findTSPPath(mst, startingNode, endingNode);
    String fullTspPath = tspPath.join(' -> ');

    List<TableRow> tspTableRows = buildTSPTable(mst, tspPath);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prim\'s Algorithm + TSP'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            const Text(
              'Graph Edges:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: edges.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      '${edges[index].startNode} -> ${edges[index].endNode}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    subtitle: Text(
                      'Weight: ${edges[index].weight}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Minimum Spanning Tree (MST):',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8.0),
            Text(
              mstWeightText, // Display total weight here
              style: const TextStyle(fontSize: 16),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: mst.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      '${mst[index].startNode} -> ${mst[index].endNode}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    subtitle: Text(
                      'Weight: ${mst[index].weight}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'TSP Path:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8.0),
            Text(
              fullTspPath,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),
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

  List<Edge> primAlgorithm(
      List<Edge> edges, String startingNode, String endingNode) {
    // Create a map to store the adjacent edges for each node
    Map<String, List<Edge>> adjacencyMap = {};

    // Populate the adjacency map
    for (Edge edge in edges) {
      if (!adjacencyMap.containsKey(edge.startNode)) {
        adjacencyMap[edge.startNode] = [];
      }
      if (!adjacencyMap.containsKey(edge.endNode)) {
        adjacencyMap[edge.endNode] = [];
      }
      adjacencyMap[edge.startNode]!.add(edge);
      adjacencyMap[edge.endNode]!.add(edge);
    }

    // Create a set to track visited nodes
    Set<String> visited = {};

    // Create a list to store the Minimum Spanning Tree (MST) edges
    List<Edge> mst = [];

    // Start with the startingNode
    String currentNode = startingNode;

    // Repeat until the endingNode is reached
    while (currentNode != endingNode) {
      // Mark the current node as visited
      visited.add(currentNode);

      Edge minEdge = Edge('', '', '');

      // Find the minimum weight edge connecting visited and unvisited nodes
      for (Edge edge in adjacencyMap[currentNode]!) {
        if ((!visited.contains(edge.startNode) &&
                visited.contains(edge.endNode)) ||
            (visited.contains(edge.startNode) &&
                !visited.contains(edge.endNode))) {
          if (minEdge.startNode.isEmpty ||
              int.parse(edge.weight) < int.parse(minEdge.weight)) {
            minEdge = edge;
          }
        }
      }

      // Add the minimum weight edge to the MST
      mst.add(minEdge);

      // Update the current node
      currentNode = visited.contains(minEdge.startNode)
          ? minEdge.endNode
          : minEdge.startNode;
    }

    return mst;
  }

  List<String> findTSPPath(
      List<Edge> mst, String startingNode, String endingNode) {
    // Create a map to store the adjacent nodes for each node in the MST
    Map<String, List<String>> adjacencyMap = {};

    // Populate the adjacency map based on the MST
    for (Edge edge in mst) {
      if (!adjacencyMap.containsKey(edge.startNode)) {
        adjacencyMap[edge.startNode] = [];
      }
      if (!adjacencyMap.containsKey(edge.endNode)) {
        adjacencyMap[edge.endNode] = [];
      }
      adjacencyMap[edge.startNode]!.add(edge.endNode);
      adjacencyMap[edge.endNode]!.add(edge.startNode);
    }

    // Perform a Depth-First Search (DFS) to find the TSP path from endingNode to startingNode
    List<String> tspPath = [];
    Set<String> visited = {};

    void dfs(String currentNode) {
      visited.add(currentNode);

      for (String neighbor in adjacencyMap[currentNode]!) {
        if (!visited.contains(neighbor)) {
          dfs(neighbor);
        }
      }

      tspPath.add(currentNode);
    }

    dfs(endingNode);
    tspPath.add(startingNode);

    return tspPath.reversed.toList();
  }

  List<TableRow> buildTSPTable(List<Edge> mst, List<String> tspPath) {
    List<TableRow> rows = [];

    // Build the header row
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

    // Build the rows for TSP path
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
          decoration: isMSTEdge
              ? const BoxDecoration(
                  color: Colors.green,
                )
              : null,
        ),
      );
    }

    return rows;
  }
}
