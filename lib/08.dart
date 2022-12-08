import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

const maxTreeHeight = 9;

List<int> visibleTreeIndicesFromSightLine(List<int> trees) {
  int tallestTreeVisited = -1;
  List<int> visibleTreeIndices = [];
  for (int idx = 0; idx < trees.length; idx++) {
    if (trees.elementAt(idx) > tallestTreeVisited) {
      visibleTreeIndices.add(idx);
      tallestTreeVisited = trees.elementAt(idx);
    }
    // if we see a maximum height tree, all trees beyond it are not visible
    if (tallestTreeVisited == maxTreeHeight) return visibleTreeIndices;
  }
  return visibleTreeIndices;
}

int visibleTreeCount(List<List<int>> grid) {
  if (grid.isEmpty) return 0;

  Set<Point> ewVisibleTreeCoordinates = {};
  for (int x = 0; x < grid.length; x++) {
    final row = grid[x];
    final westVisibleIndices = visibleTreeIndicesFromSightLine(row);
    final eastVisibleIndices =
        visibleTreeIndicesFromSightLine(row.reversed.toList())
            .map((i) => row.length - 1 - i);
    final visibleCoordinatesForRow = {
      ...westVisibleIndices,
      ...eastVisibleIndices
    }.map((idx) => Point(x, idx));
    ewVisibleTreeCoordinates.addAll(visibleCoordinatesForRow);
  }

  Set<Point> nsVisibleTreeCoordinates = {};
  for (int y = 0; y < grid.first.length; y++) {
    final col = grid.map((row) => row[y]).toList();
    final northVisibleIndices = visibleTreeIndicesFromSightLine(col);
    final southVisibleIndices =
        visibleTreeIndicesFromSightLine(col.reversed.toList())
            .map((i) => col.length - 1 - i);
    final visibleCoordinatesForCol = {
      ...northVisibleIndices,
      ...southVisibleIndices
    }.map((idx) => Point(idx, y));
    nsVisibleTreeCoordinates.addAll(visibleCoordinatesForCol);
  }
  return {...ewVisibleTreeCoordinates, ...nsVisibleTreeCoordinates}.length;
}

int viewingDistanceFromSightLine(int height, List<int> trees) {
  final idx = trees.indexWhere((tree) => tree >= height);
  return idx >= 0 ? idx + 1 : trees.length;
}

List<List<int>> computeScenicScores(List<List<int>> grid) {
  final scenicScores = List.generate(
    grid.length,
    (int idx) => List.filled(grid[idx].length, 0),
  );

  // compute scenic scores of all interior trees
  for (int x = 1; x < grid.length - 1; x++) {
    final row = grid[x];
    for (int y = 1; y < row.length - 1; y++) {
      final col = grid.map((r) => r[y]).toList();
      final height = grid[x][y];

      final leftSightLine = row.sublist(0, y).reversed.toList();
      final rightSightLine = row.sublist(y + 1);
      final upSightLine = col.sublist(0, x).reversed.toList();
      final downSightLine = col.sublist(x + 1);

      final scenicScore = viewingDistanceFromSightLine(height, leftSightLine) *
          viewingDistanceFromSightLine(height, rightSightLine) *
          viewingDistanceFromSightLine(height, upSightLine) *
          viewingDistanceFromSightLine(height, downSightLine);

      scenicScores[x][y] = scenicScore;
    }
  }
  return scenicScores;
}

void main() {
  final input = File('inputs/08.txt').readAsLinesSync();
  final grid = input
      .map((row) => row.split('').map((i) => int.parse(i)).toList())
      .toList();

  print('The visible tree count for this grid is ${visibleTreeCount(grid)}');

  final largestScenicScore = computeScenicScores(grid).flattened.max;
  print('The largest scenic score for this grid is $largestScenicScore');
}
