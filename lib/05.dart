import 'dart:collection';
import 'dart:io';

class Stack<T> {
  final ListQueue<T> items;

  Stack() : items = ListQueue<T>();

  void push(T value) => items.addLast(value);
  void pushAll(List<T> values) => values.forEach((v) => push(v));
  T? pop() => size > 0 ? items.removeLast() : null;
  T? get peek => size > 0 ? items.last : null;
  int get size => items.length;
}

abstract class Crane {
  void moveCrates(
    List<Stack<String>> crateStacks,
    int numberOfCrates,
    int from,
    int to,
  );
}

class CrateMover9000 implements Crane {
  const CrateMover9000();

  void moveCrates(
    List<Stack<String>> crateStacks,
    int numberOfCrates,
    int from,
    int to,
  ) {
    Iterable.generate(numberOfCrates).forEach((_) {
      final crate = crateStacks[from].pop();
      if (crate != null) crateStacks[to].push(crate);
    });
  }
}

class CrateMover9001 implements Crane {
  void moveCrates(
    List<Stack<String>> crateStacks,
    int numberOfCrates,
    int from,
    int to,
  ) {
    Stack<String> cratesToMove = Stack<String>();
    Iterable.generate(numberOfCrates).forEach((_) {
      final crate = crateStacks[from].pop();
      if (crate != null) cratesToMove.push(crate);
    });
    while (cratesToMove.peek != null) {
      crateStacks[to].push(cratesToMove.pop()!);
    }
  }
}

class CargoShip {
  final Crane crane;
  final List<Stack<String>> crateStacks;

  CargoShip({
    required this.crane,
    this.crateStacks = const <Stack<String>>[],
  });

  void executeProcedure(String procedure) {
    final rearrangmentProcedureRegex =
        RegExp(r'move (?<numberOfCrates>\d+) from (?<from>\d+) to (?<to>\d+)');
    final match = rearrangmentProcedureRegex.firstMatch(procedure);
    if (match != null) {
      final numberOfCrates = int.parse(match.namedGroup('numberOfCrates')!);
      final from = int.parse(match.namedGroup('from')!) - 1;
      final to = int.parse(match.namedGroup('to')!) - 1;
      crane.moveCrates(crateStacks, numberOfCrates, from, to);
    } else {
      throw UnimplementedError('Unable to parse procedure $procedure');
    }
  }

  // naive implementation -- assumes the cargo ship will have
  // no more than 9 stacks of crates
  factory CargoShip.fromString(String s, {required Crane crane}) {
    final lines = s.split('\n').reversed.toList();
    final numberOfStacks = ((lines.first.length) - 3 ~/ 4) + 1;
    final crateStacks =
        List<Stack<String>>.generate(numberOfStacks, (_) => Stack<String>());
    lines.skip(1).forEach((row) {
      for (int i = 0; i < numberOfStacks; i += 1) {
        final int col = (i * 4) + 1;
        if (row.length > col && row[col] != " ") {
          crateStacks[i].push(row[col]);
        }
      }
    });
    return CargoShip(crane: crane, crateStacks: crateStacks);
  }

  String get stackTopMessage => crateStacks.map((cs) => cs.peek ?? "").join();
}

void main() {
  final input = new File('inputs/05.txt').readAsStringSync();
  final shipInitialState = input.split('\n\n')[0];

  final cargoShipA = CargoShip.fromString(
    shipInitialState,
    crane: CrateMover9000(),
  );

  final cargoShipB = CargoShip.fromString(
    shipInitialState,
    crane: CrateMover9001(),
  );

  final procedures = input.split('\n\n')[1].split('\n');
  procedures.forEach((procedure) {
    cargoShipA.executeProcedure(procedure);
    cargoShipB.executeProcedure(procedure);
  });

  print(
    'The final result after executing all rearrangment procedures with CrateMover9000 is ${cargoShipA.stackTopMessage}',
  );

  print(
    'The final result after executing all rearrangment procedures with CrateMover9001 is ${cargoShipB.stackTopMessage}',
  );
}
