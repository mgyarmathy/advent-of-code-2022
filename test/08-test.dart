import 'package:advent_of_code_2022/08.dart';
import 'package:test/test.dart';

void main() {
  test('visibleTreeIndicesFromSightLine', () {
    expect(visibleTreeIndicesFromSightLine([]), []);
    expect(visibleTreeIndicesFromSightLine([1]), [0]);
    expect(visibleTreeIndicesFromSightLine([2, 1]), [0]);
    expect(visibleTreeIndicesFromSightLine([1, 2]), [0, 1]);
    expect(visibleTreeIndicesFromSightLine([1, 3, 2]), [0, 1]);
    expect(visibleTreeIndicesFromSightLine([1, 3, 5]), [0, 1, 2]);
  });

  group('visibleTreeCount', () {
    test('empty', () => expect(visibleTreeCount([]), 0));
    test(
      '\n1',
      () => expect(
        visibleTreeCount([
          [1],
        ]),
        1,
      ),
    );
    test(
      '\n12'
      '\n04',
      () => expect(
        visibleTreeCount([
          [1, 2],
          [0, 4],
        ]),
        4,
      ),
    );
    test(
      '\n123'
      '\n042'
      '\n371',
      () => expect(
        visibleTreeCount([
          [1, 2, 3],
          [0, 4, 2],
          [3, 7, 1],
        ]),
        9,
      ),
    );
    test(
      '\n123'
      '\n202'
      '\n371',
      () => expect(
        visibleTreeCount([
          [1, 2, 3],
          [2, 0, 2],
          [3, 7, 1],
        ]),
        8,
      ),
    );
    test(
      '\n30373'
      '\n25512'
      '\n65332'
      '\n33549'
      '\n35390',
      () => expect(
        visibleTreeCount([
          [3, 0, 3, 7, 3],
          [2, 5, 5, 1, 2],
          [6, 5, 3, 3, 2],
          [3, 3, 5, 4, 9],
          [3, 5, 3, 9, 0],
        ]),
        21,
      ),
    );
  });

  group('computeScenicScores', () {
    test('empty', () => expect(computeScenicScores([]), []));
    test(
      '\n1',
      () => expect(
        computeScenicScores([
          [1],
        ]),
        [
          [0],
        ],
      ),
    );
    test(
      '\n12'
      '\n04',
      () => expect(
          computeScenicScores([
            [1, 2],
            [0, 4],
          ]),
          [
            [0, 0],
            [0, 0],
          ]),
    );
    test(
      '\n123'
      '\n102'
      '\n371',
      () => expect(
        computeScenicScores([
          [1, 2, 3],
          [1, 0, 2],
          [3, 7, 1],
        ]),
        [
          [0, 0, 0],
          [0, 1, 0],
          [0, 0, 0],
        ],
      ),
    );
    test(
      '\n123'
      '\n292'
      '\n371',
      () => expect(
        computeScenicScores([
          [1, 2, 3],
          [2, 9, 2],
          [3, 7, 1],
        ]),
        [
          [0, 0, 0],
          [0, 1, 0],
          [0, 0, 0],
        ],
      ),
    );
    test(
      '\n30373'
      '\n25512'
      '\n65332'
      '\n33549'
      '\n35390',
      () => expect(
        computeScenicScores([
          [3, 0, 3, 7, 3],
          [2, 5, 5, 1, 2],
          [6, 5, 3, 3, 2],
          [3, 3, 5, 4, 9],
          [3, 5, 3, 9, 0],
        ]),
        [
          [0, 0, 0, 0, 0],
          [0, 1, 4, 1, 0],
          [0, 6, 1, 2, 0],
          [0, 1, 8, 3, 0],
          [0, 0, 0, 0, 0],
        ],
      ),
    );
  });
}
