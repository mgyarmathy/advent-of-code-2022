import 'package:advent_of_code_2022/13.dart';
import 'package:test/test.dart';

void main() {
  group('isOrdered', () {
    test(
      '== Pair 1 ==\nleft: [1,1,3,1,1]\nright: [1,1,5,1,1]\nisOrdered: true',
      () => expect(
        isOrdered(
          '[1,1,3,1,1]',
          '[1,1,5,1,1]',
        ),
        true,
      ),
    );
    test(
      '== Pair 2 ==\nleft: [[1],[2,3,4]]\nright: [[1],4]\nisOrdered: true',
      () => expect(
        isOrdered(
          '[[1],[2,3,4]]',
          '[[1],4]',
        ),
        true,
      ),
    );
    test(
      '== Pair 3 ==\nleft: [9]\nright: [[8,7,6]]\nisOrdered: false',
      () => expect(
        isOrdered(
          '[9]',
          '[[8,7,6]]',
        ),
        false,
      ),
    );
    test(
      '== Pair 4 ==\nleft: [[4,4],4,4]\nright: [[4,4],4,4,4]\nisOrdered: true',
      () => expect(
        isOrdered(
          '[[4,4],4,4]',
          '[[4,4],4,4,4]',
        ),
        true,
      ),
    );
    test(
      '== Pair 5 ==\nleft: [7,7,7,7]\nright: [7,7,7]\nisOrdered: false',
      () => expect(
        isOrdered(
          '[7,7,7,7]',
          '[7,7,7]',
        ),
        false,
      ),
    );
    test(
      '== Pair 6 ==\nleft: []\nright: [3]\nisOrdered: true',
      () => expect(
        isOrdered(
          '[]',
          '[3]',
        ),
        true,
      ),
    );
    test(
      '== Pair 7 ==\nleft: [[[]]]\nright: [[]]\nisOrdered: false',
      () => expect(
        isOrdered(
          '[[[]]]',
          '[[]]',
        ),
        false,
      ),
    );
    test(
      '== Pair 8 ==\nleft: [1,[2,[3,[4,[5,6,7]]]],8,9]\nright: [1,[2,[3,[4,[5,6,0]]]],8,9]\nisOrdered: false',
      () => expect(
        isOrdered(
          '[1,[2,[3,[4,[5,6,7]]]],8,9]',
          '[1,[2,[3,[4,[5,6,0]]]],8,9]',
        ),
        false,
      ),
    );
  });
}
