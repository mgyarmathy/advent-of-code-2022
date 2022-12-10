import 'dart:io';
import 'dart:math';

class Force {
  final int dX;
  final int dY;

  const Force(this.dX, this.dY);

  static Force Up = Force(0, -1);
  static Force Down = Force(0, 1);
  static Force Left = Force(-1, 0);
  static Force Right = Force(1, 0);

  factory Force.fromString(String s) {
    switch (s) {
      case "U":
        return Up;
      case "D":
        return Down;
      case "L":
        return Left;
      case "R":
        return Right;
    }
    throw UnimplementedError("Unable to parse Force for $s");
  }
}

extension on Point<int> {
  Point<int> applyForce(Force force) {
    return Point<int>(x + force.dX, y + force.dY);
  }

  bool adjacentToOrOverlapping(Point<int> other) => distanceTo(other) <= sqrt2;
}

class Rope {
  List<Point<int>> knots;

  Point<int> get head => knots.first;
  Point<int> get tail => knots.last;

  Rope(int numKnots) : knots = List.generate(numKnots, (_) => Point(0, 0));
  Rope.fromKnotPositions(this.knots);

  void moveHead(Force force) => _yankKnot(0, force);

  void _yankKnot(int idx, Force force) {
    knots[idx] = knots[idx].applyForce(force);
    // if we're not at the end of the rope
    if (idx < knots.length - 1) {
      // check to see if we need to reposition the next knot
      if (!knots[idx].adjacentToOrOverlapping(knots[idx + 1])) {
        final dX = knots[idx].x - knots[idx + 1].x;
        final dY = knots[idx].y - knots[idx + 1].y;
        if (knots[idx].distanceTo(knots[idx + 1]) > sqrt2) {
          _yankKnot(idx + 1, Force(dX.sign, dY.sign));
        } else if (dX.abs() == 2) {
          _yankKnot(idx + 1, Force(dX.sign, 0));
        } else if (dY.abs() == 2) {
          _yankKnot(idx + 1, Force(0, dY.sign));
        }
      }
    }
  }
}

void main() {
  final input = File('inputs/09.txt').readAsLinesSync();

  final twoKnotRope = Rope(2);
  final twoKnotRopeTailPositions = {twoKnotRope.tail};

  final tenKnotRope = Rope(10);
  final tenKnotRopeTailPositions = {tenKnotRope.tail};

  for (final motion in input) {
    final direction = Force.fromString(motion.split(' ')[0]);
    final steps = int.parse(motion.split(' ')[1]);

    Iterable.generate(steps).forEach((_) {
      twoKnotRope.moveHead(direction);
      twoKnotRopeTailPositions.add(twoKnotRope.tail);

      tenKnotRope.moveHead(direction);
      tenKnotRopeTailPositions.add(tenKnotRope.tail);
    });
  }

  print(
    'The tail of the two-knot rope visited ${twoKnotRopeTailPositions.length} unique positions\n'
    'The tail of the ten-knot rope visited ${tenKnotRopeTailPositions.length} unique positions',
  );
}
