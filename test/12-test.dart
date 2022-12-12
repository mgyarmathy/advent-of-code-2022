import 'dart:math';

import 'package:advent_of_code_2022/12.dart';
import 'package:test/test.dart';

void main() {
  group(ElevationMap, () {
    test('example', () {
      final elevationMap = ElevationMap.fromString(
        'Sabqponm\n'
        'abcryxwl\n'
        'accszExk\n'
        'acctuvwj\n'
        'abdefghi',
      );
      // v..v<<<<
      // >v.vv<<^
      // .>vv>E^^
      // ..v>>>^^
      // ..>>>>>^
      final shortestPath = elevationMap.shortestPath(
        elevationMap.startPoint,
        elevationMap.endPoint,
      );
      expect(shortestPath, [
        Point(0, 0),
        Point(0, 1),
        Point(1, 1),
        Point(1, 2),
        Point(2, 2),
        Point(2, 3),
        Point(2, 4),
        Point(3, 4),
        Point(4, 4),
        Point(5, 4),
        Point(6, 4),
        Point(7, 4),
        Point(7, 3),
        Point(7, 2),
        Point(7, 1),
        Point(7, 0),
        Point(6, 0),
        Point(5, 0),
        Point(4, 0),
        Point(3, 0),
        Point(3, 1),
        Point(3, 2),
        Point(3, 3),
        Point(4, 3),
        Point(5, 3),
        Point(6, 3),
        Point(6, 2),
        Point(6, 1),
        Point(5, 1),
        Point(4, 1),
        Point(4, 2),
      ]);
      expect(shortestPath!.length, 31);
    });
  });
}
