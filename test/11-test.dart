import 'package:advent_of_code_2022/11.dart';
import 'package:test/test.dart';

void main() {
  group(KeepAwaySimulation, () {
    final example = ''
        'Monkey 0:\n'
        '  Starting items: 79, 98\n'
        '  Operation: new = old * 19\n'
        '  Test: divisible by 23\n'
        '    If true: throw to monkey 2\n'
        '    If false: throw to monkey 3\n'
        '\n'
        'Monkey 1:\n'
        '  Starting items: 54, 65, 75, 74\n'
        '  Operation: new = old + 6\n'
        '  Test: divisible by 19\n'
        '    If true: throw to monkey 2\n'
        '    If false: throw to monkey 0\n'
        '\n'
        'Monkey 2:\n'
        '  Starting items: 79, 60, 97\n'
        '  Operation: new = old * old\n'
        '  Test: divisible by 13\n'
        '    If true: throw to monkey 1\n'
        '    If false: throw to monkey 3\n'
        '\n'
        'Monkey 3:\n'
        '  Starting items: 74\n'
        '  Operation: new = old + 3\n'
        '  Test: divisible by 17\n'
        '    If true: throw to monkey 0\n'
        '    If false: throw to monkey 1\n';

    test('first simulation', () {
      final simulation = KeepAwaySimulation.fromString(
        example,
        (int worryFactor) => worryFactor ~/ 3,
      );
      Iterable.generate(20).forEach((_) => simulation.nextRound());
      expect(simulation.monkeyBusinessLevel, 10605);
    });

    test('longer simulation', () {
      final monkeys =
          example.split('\n\n').map((m) => Monkey.fromString(m)).toList();
      final simulation = KeepAwaySimulation(
        monkeys,
        (int worryFactor) =>
            worryFactor %
            monkeys.map((m) => m.testDivisor).reduce((value, i) => value * i),
      );
      Iterable.generate(10000).forEach((_) => simulation.nextRound());
      expect(simulation.monkeyBusinessLevel, 2713310158);
    });
  });
}
