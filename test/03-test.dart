import 'package:test/test.dart';
import 'package:advent_of_code_2022/03.dart';

void main() {
  test('RucksackItem#priority', () {
    expect(RucksackItem('a').priority, 1);
    expect(RucksackItem('z').priority, 26);
    expect(RucksackItem('A').priority, 27);
    expect(RucksackItem('Z').priority, 52);
  });

  test('Rucksack#commonItemsPrioritySum', () {
    expect(Rucksack.fromString('').commonItemsPrioritySum, 0);
    expect(
        Rucksack.fromString('vJrwpWtwJgWrhcsFMMfFFhFp').commonItemsPrioritySum,
        16);
    expect(
        Rucksack.fromString('jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL')
            .commonItemsPrioritySum,
        38);
    expect(
        Rucksack.fromString('PmmdzqPrVvPwwTWBwg').commonItemsPrioritySum, 42);
    expect(
        Rucksack.fromString('wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn')
            .commonItemsPrioritySum,
        22);
    expect(Rucksack.fromString('ttgJtRGJQctTZtZT').commonItemsPrioritySum, 20);
    expect(
        Rucksack.fromString('CrZsJsPPZsGzwwsLwLmpwMDw').commonItemsPrioritySum,
        19);
  });
}
