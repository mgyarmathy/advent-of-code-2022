import 'package:advent_of_code_2022/05.dart';
import 'package:test/test.dart';

void main() {
  group(CargoShip, () {
    group('#stackTopMessage', () {
      test('returns the top character from each stack', () {
        final cargoShip = CargoShip(
          crane: CrateMover9000(),
          crateStacks: [
            Stack<String>()..pushAll(["B", "C"]),
            Stack<String>()..pushAll(["A"]),
          ],
        );
        expect(cargoShip.stackTopMessage, "CA");
      });
      test('skips over empty stacks', () {
        final cargoShip = CargoShip(
          crane: CrateMover9000(),
          crateStacks: [
            Stack<String>()..pushAll(["A", "B"]),
            Stack<String>()..pushAll([]),
            Stack<String>()..pushAll(["D"]),
          ],
        );

        expect(cargoShip.stackTopMessage, "BD");
      });
    });

    test('.fromString initializes the ship state from an ASCII representation',
        () {
      final cargoShip = CargoShip.fromString(
        '    [D]    \n'
        '[N] [C]    \n'
        '[Z] [M] [P]\n'
        ' 1   2   3 ',
        crane: CrateMover9000(),
      );

      expect(cargoShip.stackTopMessage, "NDP");
    });
  });
  group(CrateMover9000, () {
    test('#moveCrates moves crates from one stack to another, one at a time',
        () {
      final crane = CrateMover9000();
      final crateStacks = [
        Stack<String>()..pushAll(["Z", "N"]),
        Stack<String>()..pushAll(["M", "C", "D"]),
        Stack<String>()..pushAll(["P"]),
      ];
      /*
          [D]    
      [N] [C]    
      [Z] [M] [P]
       1   2   3 
      */

      // move 1 from 2 to 1
      crane.moveCrates(crateStacks, 1, 1, 0);
      /*
      [D]        
      [N] [C]    
      [Z] [M] [P]
       1   2   3 
      */
      expect(crateStacks[0].peek, "D");
      expect(crateStacks[0].size, 3);
      expect(crateStacks[1].peek, "C");
      expect(crateStacks[1].size, 2);

      // move 3 from 1 to 3
      crane.moveCrates(crateStacks, 3, 0, 2);
      /*
              [Z]
              [N]
          [C] [D]
          [M] [P]
       1   2   3
      */
      expect(crateStacks[0].peek, null);
      expect(crateStacks[0].size, 0);
      expect(crateStacks[2].peek, "Z");
      expect(crateStacks[2].size, 4);
    });
  });

  group(CrateMover9001, () {
    test(
        '#moveCrates moves multiple crates from one stack to another, all at once',
        () {
      final crane = CrateMover9001();
      final crateStacks = [
        Stack<String>()..pushAll(["Z", "N"]),
        Stack<String>()..pushAll(["M", "C", "D"]),
        Stack<String>()..pushAll(["P"]),
      ];
      /*
          [D]    
      [N] [C]    
      [Z] [M] [P]
       1   2   3 
      */

      // move 1 from 2 to 1
      crane.moveCrates(crateStacks, 1, 1, 0);
      /*
      [D]        
      [N] [C]    
      [Z] [M] [P]
       1   2   3 
      */
      expect(crateStacks[0].peek, "D");
      expect(crateStacks[0].size, 3);
      expect(crateStacks[1].peek, "C");
      expect(crateStacks[1].size, 2);

      // move 3 from 1 to 3
      crane.moveCrates(crateStacks, 3, 0, 2);
      /*
              [D]
              [N]
          [C] [Z]
          [M] [P]
       1   2   3
      */
      expect(crateStacks[0].peek, null);
      expect(crateStacks[0].size, 0);
      expect(crateStacks[2].peek, "D");
      expect(crateStacks[2].size, 4);
    });
  });
}
