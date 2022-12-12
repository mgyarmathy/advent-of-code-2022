import 'package:advent_of_code_2022/10.dart';
import 'package:test/test.dart';

void main() {
  group(CPU, () {
    test('simple example', () {
      expect(
        new CPU()
            .executeProgram([Noop(), AddX(3), AddX(-5)])
            .take(8)
            .map((cpu) => [cpu.cycleNumber, cpu.registerX, cpu.signalStrength])
            .toList(),
        [
          [1, 1, 1],
          [2, 1, 2],
          [3, 1, 3],
          [4, 4, 16],
          [5, 4, 20],
          [6, -1, -6],
          [7, -1, -7],
          [8, -1, -8],
        ],
      );
    });
    group('full example', () {
      final program = [
        'addx 15',
        'addx -11',
        'addx 6',
        'addx -3',
        'addx 5',
        'addx -1',
        'addx -8',
        'addx 13',
        'addx 4',
        'noop',
        'addx -1',
        'addx 5',
        'addx -1',
        'addx 5',
        'addx -1',
        'addx 5',
        'addx -1',
        'addx 5',
        'addx -1',
        'addx -35',
        'addx 1',
        'addx 24',
        'addx -19',
        'addx 1',
        'addx 16',
        'addx -11',
        'noop',
        'noop',
        'addx 21',
        'addx -15',
        'noop',
        'noop',
        'addx -3',
        'addx 9',
        'addx 1',
        'addx -3',
        'addx 8',
        'addx 1',
        'addx 5',
        'noop',
        'noop',
        'noop',
        'noop',
        'noop',
        'addx -36',
        'noop',
        'addx 1',
        'addx 7',
        'noop',
        'noop',
        'noop',
        'addx 2',
        'addx 6',
        'noop',
        'noop',
        'noop',
        'noop',
        'noop',
        'addx 1',
        'noop',
        'noop',
        'addx 7',
        'addx 1',
        'noop',
        'addx -13',
        'addx 13',
        'addx 7',
        'noop',
        'addx 1',
        'addx -33',
        'noop',
        'noop',
        'noop',
        'addx 2',
        'noop',
        'noop',
        'noop',
        'addx 8',
        'noop',
        'addx -1',
        'addx 2',
        'addx 1',
        'noop',
        'addx 17',
        'addx -9',
        'addx 1',
        'addx 1',
        'addx -3',
        'addx 11',
        'noop',
        'noop',
        'addx 1',
        'noop',
        'addx 1',
        'noop',
        'noop',
        'addx -13',
        'addx -19',
        'addx 1',
        'addx 3',
        'addx 26',
        'addx -30',
        'addx 12',
        'addx -1',
        'addx 3',
        'addx 1',
        'noop',
        'noop',
        'noop',
        'addx -9',
        'addx 18',
        'addx 1',
        'addx 2',
        'noop',
        'noop',
        'addx 9',
        'noop',
        'noop',
        'noop',
        'addx -1',
        'addx 2',
        'addx -37',
        'addx 1',
        'addx 3',
        'noop',
        'addx 15',
        'addx -21',
        'addx 22',
        'addx -6',
        'addx 1',
        'noop',
        'addx 2',
        'addx 1',
        'noop',
        'addx -10',
        'noop',
        'noop',
        'addx 20',
        'addx 1',
        'addx 2',
        'addx 2',
        'addx -6',
        'addx -11',
        'noop',
        'noop',
        'noop',
      ];
      test('registerX is the expected value during a set of cycles', () {
        expect(
          new CPU()
              .executeProgram(
                program.map((s) => Instruction.fromString(s)).toList(),
              )
              .take(220)
              .where((cpu) =>
                  [20, 60, 100, 140, 180, 220].contains(cpu.cycleNumber))
              .map((cpu) => cpu.registerX)
              .toList(),
          [
            21,
            19,
            18,
            21,
            16,
            18,
          ],
        );
      });
      test('draws the expected pixels', () {
        expect(
          new CPU().drawProgram(
            program.map((s) => Instruction.fromString(s)).toList(),
          ),
          '##..##..##..##..##..##..##..##..##..##..\n'
          '###...###...###...###...###...###...###.\n'
          '####....####....####....####....####....\n'
          '#####.....#####.....#####.....#####.....\n'
          '######......######......######......####\n'
          '#######.......#######.......#######.....',
        );
      });
    });
  });
}
