import 'dart:io';

class Elf {
  final List<int> foodCalories;

  int get totalFoodCalories => foodCalories.reduce((sum, item) => sum += item);

  Elf(this.foodCalories);
}

void main() {
  final input = new File('01-input.txt').readAsStringSync();
  final elves = input.split('\n\n').map((e) {
    final foodCalories = e.split('\n').map((i) => int.parse(i)).toList();
    return new Elf(foodCalories);
  });

  final sortedElves = elves.map((e) => e.totalFoodCalories).toList()
    ..sort((a, b) => b.compareTo(a));

  final maxElfCalories = sortedElves.first;
  print(
    "The elf carrying the most calories is carrying $maxElfCalories calories",
  );

  final topThreeElfCaloriesTotal =
      sortedElves.take(3).reduce((sum, item) => sum += item);
  print(
    "The top three elves are carrying a total of $topThreeElfCaloriesTotal calories",
  );
}
