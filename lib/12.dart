import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

extension on Point<int> {
  int manhattanDistanceTo(Point<int> other) =>
      (x - other.x).abs() + (y - other.y).abs();
}

class ElevationPoint extends Point<int> {
  final String elevation;

  ElevationPoint(super.x, super.y, this.elevation);

  int get altitude => (elevation == 'E'
          ? 'z'
          : elevation == 'S'
              ? 'a'
              : elevation)
      .codeUnitAt(0);

  bool isAccessibleFrom(ElevationPoint other) => altitude - other.altitude <= 1;

  @override
  String toString() => 'ElevationPoint($x, $y, "$elevation")';
}

class ElevationMap {
  final List<List<ElevationPoint>> grid;

  ElevationMap(this.grid);

  int get maxX => grid.first.length - 1;
  int get maxY => grid.length - 1;

  ElevationPoint get startPoint =>
      grid.flattened.firstWhere((p) => p.elevation == 'S');
  ElevationPoint get endPoint =>
      grid.flattened.firstWhere((p) => p.elevation == 'E');

  List<Point<int>>? shortestPath(Point<int> start, Point<int> end) {
    if (start.y >= grid.length || start.x >= grid[start.y].length) return null;
    if (end.y >= grid.length || end.x >= grid[end.y].length) return null;
    final queue = ListQueue<List<ElevationPoint>>();
    final visitedPoints = {grid[start.y][start.x]};
    queue.addLast([grid[start.y][start.x]]);
    while (queue.isNotEmpty) {
      final path = queue.removeFirst();
      final curr = path.last;
      final adjacentPoints = [
        if (curr.y > 0) grid[curr.y - 1][curr.x],
        if (curr.y < maxY) grid[curr.y + 1][curr.x],
        if (curr.x > 0) grid[curr.y][curr.x - 1],
        if (curr.x < maxX) grid[curr.y][curr.x + 1],
      ];
      final nextSteps = adjacentPoints
          .where((p) => p.isAccessibleFrom(curr) && !visitedPoints.contains(p));

      // shortest path found
      if (nextSteps.contains(end)) return path;

      // bonus heuristic -- greedily try next steps that are closer to the goal
      final nextStepsSortedByProximityToGoal = nextSteps.sorted(
        (a, b) => a.manhattanDistanceTo(end) - b.manhattanDistanceTo(end),
      );

      nextStepsSortedByProximityToGoal.forEach((p) {
        queue.addLast([...path, p]);
        visitedPoints.add(p);
      });
    }
    return null;
  }

  factory ElevationMap.fromString(String s) {
    final rows = s.split('\n');
    final List<List<ElevationPoint>> grid = [];
    for (int y = 0; y < rows.length; y++) {
      grid.add([]);
      for (int x = 0; x < rows[y].length; x++) {
        grid[y].add(ElevationPoint(x, y, rows[y][x]));
      }
    }
    return ElevationMap(grid);
  }
}

void main() {
  final input = File('inputs/12.txt').readAsStringSync();

  final elevationMap = ElevationMap.fromString(input);
  final shortestPath =
      elevationMap.shortestPath(elevationMap.startPoint, elevationMap.endPoint);
  print(
    'The shortest path to reach the destination has ${shortestPath!.length} steps',
  );

  final lowestPoints = elevationMap.grid.flattened
      .where((p) => p.elevation == 'a' || p.elevation == 'S');
  final shortestPathFromLowestElevation = lowestPoints
      .map((p) => elevationMap.shortestPath(p, elevationMap.endPoint))
      .whereNotNull()
      .sorted((a, b) => a.length - b.length)
      .first;
  print(
    'The shortest path from any low point to reach the destination has ${shortestPathFromLowestElevation.length} steps',
  );
}
