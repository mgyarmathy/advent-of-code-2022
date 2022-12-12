import 'dart:io';
import 'package:collection/collection.dart';

class InspectResult {
  final int nextTarget;
  final int newWorryLevel;

  InspectResult(this.nextTarget, this.newWorryLevel);
}

class Monkey {
  final List<int> items;
  final String operationString;
  final int Function(int) operation;
  final int testDivisor;
  final int testPassTarget;
  final int testFailTarget;

  int inspectCount = 0;

  Monkey(
    this.items,
    this.operationString,
    this.operation,
    this.testDivisor,
    this.testPassTarget,
    this.testFailTarget,
  );

  InspectResult? inspectNext(int Function(int) relaxFunction) {
    if (items.length == 0) return null;
    inspectCount++;
    final item = items.removeAt(0);
    final newWorryLevel = relaxFunction(operation(item));
    final nextTarget =
        newWorryLevel % testDivisor == 0 ? testPassTarget : testFailTarget;
    return InspectResult(nextTarget, newWorryLevel);
  }

  factory Monkey.fromString(String s) {
    final regex = new RegExp(
        r'Monkey (?<id>\d)\:\n  Starting items\: (?<items>.+)\n  Operation\: new = (?<operation>.*)\n  Test\: divisible by (?<testDivisor>\d+)\n    If true\: throw to monkey (?<testPassTarget>\d+)\n    If false\: throw to monkey (?<testFailTarget>\d+)');
    final match = regex.firstMatch(s);
    if (match != null) {
      final items = match
          .namedGroup('items')!
          .split(', ')
          .map((i) => int.parse(i))
          .toList();
      final operationString = match.namedGroup('operation')!;
      final operation = parseOperation(operationString);
      final testDivisor = int.parse(match.namedGroup('testDivisor')!);
      final testPassTarget = int.parse(match.namedGroup('testPassTarget')!);
      final testFailTarget = int.parse(match.namedGroup('testFailTarget')!);
      return Monkey(
        items,
        operationString,
        operation,
        testDivisor,
        testPassTarget,
        testFailTarget,
      );
    } else {
      throw UnimplementedError('Unable to parse Monkey: $s');
    }
  }

  static int Function(int) parseOperation(String operation) {
    final operationRegex =
        RegExp(r'(?<left>old|\d+) (?<operand>\+|\*) (?<right>old|\d+)');
    final match = operationRegex.firstMatch(operation);
    if (match != null) {
      final left = match.namedGroup('left')!;
      final operand = match.namedGroup('operand')!;
      final right = match.namedGroup('right')!;
      if (operand == '+') {
        return (int old) =>
            (left == 'old' ? old : int.parse(left)) +
            (right == 'old' ? old : int.parse(right));
      } else if (operand == '*')
        return (int old) =>
            (left == 'old' ? old : int.parse(left)) *
            (right == 'old' ? old : int.parse(right));
    }
    throw UnimplementedError('Unable to parse operation: $operation');
  }
}

class KeepAwaySimulation {
  final List<Monkey> monkeys;
  final int Function(int) relaxFunction;

  KeepAwaySimulation(this.monkeys, this.relaxFunction);

  factory KeepAwaySimulation.fromString(
    String s,
    int Function(int) relaxFunction,
  ) {
    final monkeys = s.split('\n\n').map((m) => Monkey.fromString(m)).toList();
    return KeepAwaySimulation(monkeys, relaxFunction);
  }

  void nextRound() {
    for (final monkey in monkeys) {
      InspectResult? result = monkey.inspectNext(relaxFunction);
      while (result != null) {
        monkeys[result.nextTarget].items.add(result.newWorryLevel);
        result = monkey.inspectNext(relaxFunction);
      }
    }
  }

  int get monkeyBusinessLevel => monkeys
      .map((m) => m.inspectCount)
      .sorted((a, b) => b - a)
      .take(2)
      .reduce((acc, i) => acc * i);
}

void main() {
  final input = File('inputs/11.txt').readAsStringSync();

  final simulation = KeepAwaySimulation.fromString(
    input,
    (int worryFactor) => worryFactor ~/ 3,
  );
  Iterable.generate(20).forEach((_) => simulation.nextRound());
  print(
    'After 20 rounds of shenanigans, the level of monkey business is ${simulation.monkeyBusinessLevel}',
  );

  final monkeys = input.split('\n\n').map((m) => Monkey.fromString(m)).toList();
  final longerSimulation = KeepAwaySimulation(
    monkeys,
    (int worryFactor) =>
        worryFactor %
        monkeys.map((m) => m.testDivisor).reduce((val, i) => val * i),
  );
  Iterable.generate(10000).forEach((i) => longerSimulation.nextRound());
  print(
    'After 10000 rounds of shenanigans, the level of monkey business is ${longerSimulation.monkeyBusinessLevel}',
  );
}
