import 'dart:math';

import 'package:advent_of_code_2022/09.dart';
import 'package:test/test.dart';

void main() {
  group('Rope', () {
    group('#moveHead', () {
      test('tail moves to follows the head if they\'re no longer touching', () {
        // .....    .....    .....
        // .TH.. -> .T.H. -> ..TH.
        // .....    .....    .....
        final ropeA = Rope.fromKnotPositions([Point(2, 1), Point(1, 1)]);
        ropeA.moveHead(Force.Right);
        expect(ropeA.head, Point(3, 1));
        expect(ropeA.tail, Point(2, 1));

        // ...    ...    ...
        // .T.    .T.    ...
        // .H. -> ... -> .T.
        // ...    .H.    .H.
        // ...    ...    ...
        final ropeB = Rope.fromKnotPositions([Point(1, 2), Point(1, 1)]);
        ropeB.moveHead(Force.Down);
        expect(ropeB.head, Point(1, 3));
        expect(ropeB.tail, Point(1, 2));

        // .....    .....    .....
        // .....    ..H..    ..H..
        // ..H.. -> ..... -> ..T..
        // .T...    .T...    .....
        // .....    .....    .....
        final ropeC = Rope.fromKnotPositions([Point(2, 2), Point(1, 3)]);
        ropeC.moveHead(Force.Up);
        expect(ropeC.head, Point(2, 1));
        expect(ropeC.tail, Point(2, 2));

        // .....    .....    .....
        // .....    .....    .....
        // ..H.. -> ...H. -> ..TH.
        // .T...    .T...    .....
        // .....    .....    .....
        final ropeD = Rope.fromKnotPositions([Point(2, 2), Point(1, 3)]);
        ropeD.moveHead(Force.Right);
        expect(ropeD.head, Point(3, 2));
        expect(ropeD.tail, Point(2, 2));
      });
      test('tail doesn\'t move if it\'s still adjacent to the head', () {
        // .....    .....
        // .T... -> .TH..
        // ..H..    .....
        final rope = Rope.fromKnotPositions([Point(2, 2), Point(1, 1)]);
        rope.moveHead(Force.Up);
        expect(rope.head, Point(2, 1));
        expect(rope.tail, Point(1, 1));

        // .....    ..H..
        // .TH.. -> .T...
        // .....    .....
        rope.moveHead(Force.Up);
        expect(rope.head, Point(2, 0));
        expect(rope.tail, Point(1, 1));

        // ..H..    .H...
        // .T... -> .T...
        // .....    .....
        rope.moveHead(Force.Left);
        expect(rope.head, Point(1, 0));
        expect(rope.tail, Point(1, 1));
      });
      test(
          'for longer ropes with more knots, same behavior applies for each link',
          () {
        // == Initial State ==
        // ......
        // ......
        // ......
        // ......
        // H.....  (H covers 1, 2, 3, 4, 5, 6, s)
        final rope = Rope.fromKnotPositions(
          List.generate(7, (_) => Point(0, 4)),
        );

        // == R 4 ==
        // ......    ......
        // ......    ......
        // ...... -> ......
        // ......    ......
        // H.....    4321H.  (4 covers 5, 6, s)
        Iterable.generate(4).forEach((_) => rope.moveHead(Force.Right));
        expect(rope.knots, [
          Point(4, 4),
          Point(3, 4),
          Point(2, 4),
          Point(1, 4),
          Point(0, 4),
          Point(0, 4),
          Point(0, 4),
        ]);

        // == U 4 ==
        // ......    ....H.
        // ......    ....1.
        // ...... -> ..432.
        // ......    .5....
        // 4321H.    6.....
        Iterable.generate(4).forEach((_) => rope.moveHead(Force.Up));
        expect(rope.knots, [
          Point(4, 0),
          Point(4, 1),
          Point(4, 2),
          Point(3, 2),
          Point(2, 2),
          Point(1, 3),
          Point(0, 4),
        ]);

        // == L 3 ==
        // ....H.    .H1...
        // ....1.    ...2..
        // ..432. -> ..43..
        // .5....    .5....
        // 6.....    6.....
        Iterable.generate(3).forEach((_) => rope.moveHead(Force.Left));
        expect(rope.knots, [
          Point(1, 0),
          Point(2, 0),
          Point(3, 1),
          Point(3, 2),
          Point(2, 2),
          Point(1, 3),
          Point(0, 4),
        ]);

        // == D 1 ==
        // .H1...    ..1...
        // ...2..    .H.2..
        // ..43.. -> ..43..
        // .5....    .5....
        // 6.....    6.....
        rope.moveHead(Force.Down);
        expect(rope.knots, [
          Point(1, 1),
          Point(2, 0),
          Point(3, 1),
          Point(3, 2),
          Point(2, 2),
          Point(1, 3),
          Point(0, 4),
        ]);

        // == R 4 ==
        // ..1...    ......
        // .H.2..    ...21H
        // ..43.. -> ..43..
        // .5....    .5....
        // 6.....    6.....
        Iterable.generate(4).forEach((_) => rope.moveHead(Force.Right));
        expect(rope.knots, [
          Point(5, 1),
          Point(4, 1),
          Point(3, 1),
          Point(3, 2),
          Point(2, 2),
          Point(1, 3),
          Point(0, 4),
        ]);

        // == D 1 ==
        // ......    ......
        // ...21H    ...21.
        // ..43.. -> ..43.H
        // .5....    .5....
        // 6.....    6.....
        rope.moveHead(Force.Down);
        expect(rope.knots, [
          Point(5, 2),
          Point(4, 1),
          Point(3, 1),
          Point(3, 2),
          Point(2, 2),
          Point(1, 3),
          Point(0, 4),
        ]);

        // == L 5 ==
        // ......    ......
        // ...21.    ......
        // ..43.H -> H123..
        // .5....    .5....
        // 6.....    6.....
        Iterable.generate(5).forEach((_) => rope.moveHead(Force.Left));
        expect(rope.knots, [
          Point(0, 2),
          Point(1, 2),
          Point(2, 2),
          Point(3, 2),
          Point(2, 2),
          Point(1, 3),
          Point(0, 4),
        ]);

        // == R 2 ==
        // ......    ......
        // ......    ......
        // H123.. -> .1H3..
        // .5....    .5....
        // 6.....    6.....
        Iterable.generate(2).forEach((_) => rope.moveHead(Force.Right));
        expect(rope.knots, [
          Point(2, 2),
          Point(1, 2),
          Point(2, 2),
          Point(3, 2),
          Point(2, 2),
          Point(1, 3),
          Point(0, 4),
        ]);
      });
    });
  });
}
