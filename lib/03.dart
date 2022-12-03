import 'dart:io';

import 'package:collection/collection.dart';

class RucksackItem {
  final String value;

  const RucksackItem(this.value);

  int get priority {
    final i = value.codeUnitAt(0);
    return i >= 97 ? i - 96 : i - 38;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RucksackItem &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class Rucksack {
  final Set<RucksackItem> firstCompartmentItems;
  final Set<RucksackItem> secondCompartmentItems;

  Rucksack(this.firstCompartmentItems, this.secondCompartmentItems);

  factory Rucksack.fromString(String s) {
    List<RucksackItem> items = s.split('').map((c) => RucksackItem(c)).toList();
    Set<RucksackItem> firstCompartmentItems =
        items.sublist(0, items.length ~/ 2).toSet();
    Set<RucksackItem> secondCompartmentItems =
        items.sublist(items.length ~/ 2).toSet();
    return Rucksack(firstCompartmentItems, secondCompartmentItems);
  }

  Set<RucksackItem> get commonItems =>
      firstCompartmentItems.intersection(secondCompartmentItems);
  int get commonItemsPrioritySum => commonItems.map((i) => i.priority).sum;

  Set<RucksackItem> get uniqueItems =>
      {...firstCompartmentItems, ...secondCompartmentItems};
}

void main() {
  final input = new File('inputs/03.txt').readAsLinesSync();

  final rucksacks = input.map((i) => Rucksack.fromString(i));

  final totalPrioritySum = rucksacks.map((r) => r.commonItemsPrioritySum).sum;

  print('The sum of all common items from each rucksack is $totalPrioritySum');

  final rucksackGroups = rucksacks.slices(3);
  final commonItemsFromEachGroup = rucksackGroups.map((g) => g
      .map((r) => r.uniqueItems)
      .reduce((value, uniqueItems) => value.intersection(uniqueItems)));
  final totalPrioritySumOfGroupCommonItems =
      commonItemsFromEachGroup.flattened.map((i) => i.priority).sum;

  print(
    'The sum of all common items from each rucksack group is $totalPrioritySumOfGroupCommonItems',
  );
}
