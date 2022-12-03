import 'dart:io';

import 'package:collection/collection.dart';

class Elf {
  final List<int> foodCalories;

  int get totalFoodCalories => foodCalories.sum;

  const Elf(this.foodCalories);
}

void main() {
  final input = new File('inputs/01.txt').readAsStringSync();
  final elves = input.split('\n\n').map((e) {
    final foodCalories = e.split('\n').map((i) => int.parse(i)).toList();
    return Elf(foodCalories);
  });

  final sortedElves =
      elves.map((e) => e.totalFoodCalories).sorted((a, b) => b.compareTo(a));

  final maxElfCalories = sortedElves.first;
  print(
    "The elf carrying the most calories is carrying $maxElfCalories calories",
  );

  final topThreeElfCaloriesTotal = sortedElves.take(3).sum;
  print(
    "The top three elves are carrying a total of $topThreeElfCaloriesTotal calories",
  );
}
