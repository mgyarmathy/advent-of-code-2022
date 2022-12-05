import 'package:test/test.dart';
import 'package:advent_of_code_2022/04.dart';

void main() {
  test('IntRange#contains', () {
    expect(IntRange(2, 8).contains(IntRange(3, 7)), true);
    expect(IntRange(1, 1).contains(IntRange(1, 1)), true);
    expect(IntRange(1, 8).contains(IntRange(1, 7)), true);
    expect(IntRange(1, 8).contains(IntRange(2, 8)), true);
    expect(IntRange(3, 7).contains(IntRange(2, 8)), false);
    expect(IntRange(0, 1).contains(IntRange(2, 3)), false);
  });

  test('IntRange#overlaps', () {
    expect(IntRange(5, 7).overlaps(IntRange(7, 9)), true);
    expect(IntRange(2, 8).overlaps(IntRange(3, 7)), true);
    expect(IntRange(6, 6).overlaps(IntRange(4, 6)), true);
    expect(IntRange(2, 6).overlaps(IntRange(4, 8)), true);
    expect(IntRange(0, 1).overlaps(IntRange(2, 3)), false);
  });
}
