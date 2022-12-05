import 'dart:io';

class IntRange {
  final int from;
  final int to;

  const IntRange(this.from, this.to);

  factory IntRange.fromString(String str) {
    final nums = str.split('-').map((s) => int.parse(s));
    return IntRange(nums.first, nums.last);
  }

  bool contains(IntRange other) => from <= other.from && to >= other.to;
  bool overlaps(IntRange other) => from <= other.to && other.from <= to;
}

void main() {
  final input = new File('inputs/04.txt').readAsLinesSync();
  final assignmentPairFullyContainsCount = input.where((pair) {
    final a = IntRange.fromString(pair.split(',')[0]);
    final b = IntRange.fromString(pair.split(',')[1]);
    return a.contains(b) || b.contains(a);
  }).length;

  print(
    'The number of fully overlapping pairs is $assignmentPairFullyContainsCount',
  );

  final assignmentPairOverlapsCount = input.where((pair) {
    final a = IntRange.fromString(pair.split(',')[0]);
    final b = IntRange.fromString(pair.split(',')[1]);
    return a.overlaps(b);
  }).length;

  print(
    'The number of overlapping pairs is $assignmentPairOverlapsCount',
  );
}
