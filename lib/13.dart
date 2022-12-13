import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

bool _isList(String s) => s.startsWith('[') && s.endsWith(']');
bool _isInteger(String s) => !_isList(s);
String _wrap(String s) => _isList(s) ? s : '[$s]';

int comparePackets(String left, String right) {
  if (_isInteger(left) && _isInteger(right)) {
    final leftNum = int.parse(left);
    final rightNum = int.parse(right);
    if (leftNum < rightNum) return -1;
    if (leftNum > rightNum) return 1;
    return 0;
  }

  final leftList = jsonDecode(_wrap(left)) as List<dynamic>;
  final rightList = jsonDecode(_wrap(right)) as List<dynamic>;

  for (int idx = 0; idx < min(leftList.length, rightList.length); idx++) {
    // compare left and right value from lists
    final result = comparePackets(
      leftList[idx].toString().replaceAll(' ', ''),
      rightList[idx].toString().replaceAll(' ', ''),
    );
    // if they're not equal, return the result
    if (result != 0) return result;
  }

  // left list ran out first, in order
  if (leftList.length < rightList.length) return -1;
  // right list ran out first, not in order
  if (leftList.length > rightList.length) return 1;

  return 0;
}

bool isOrdered(left, right) => comparePackets(left, right) == -1;

void main() {
  final input = File('inputs/13.txt').readAsStringSync();

  final pairs = input.split('\n\n').map((p) => p.split('\n')).toList();
  final inOrderPairIndexSum = pairs.mapIndexed((idx, pair) {
    return isOrdered(pair.first, pair.last) ? idx + 1 : 0;
  }).sum;

  print(
    'The sum of the indices of the packet pairs in the right order is ${inOrderPairIndexSum}',
  );

  final packets = input.replaceAll('\n\n', '\n').split('\n').toList();
  final sortedPacketsWithDividers =
      [...packets, '[[2]]', '[[6]]'].sorted((a, b) => comparePackets(a, b));
  final decoderKey = (sortedPacketsWithDividers.indexOf('[[2]]') + 1) *
      (sortedPacketsWithDividers.indexOf('[[6]]') + 1);

  print('The decoder key for the distress signal is ${decoderKey}');
}
