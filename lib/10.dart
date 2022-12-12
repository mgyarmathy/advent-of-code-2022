import 'dart:io';
import 'package:collection/collection.dart';

abstract class Instruction {
  int tickCount = 0;
  bool tick(CPU cpu) {
    tickCount++;
    return true;
  }

  Instruction();

  factory Instruction.fromString(String s) {
    if (s == 'noop')
      return Noop();
    else if (s.startsWith('addx')) return AddX(int.parse(s.split(' ')[1]));
    throw UnimplementedError("Unable to parse Instruction for $s");
  }
}

class Noop extends Instruction {
  bool tick(CPU cpu) => super.tick(cpu);
}

class AddX extends Instruction {
  final int value;

  AddX(this.value);

  bool tick(CPU cpu) {
    super.tick(cpu);
    if (tickCount == 2) {
      cpu.registerX += value;
      return true;
    }
    return false;
  }
}

class CPUSnapshot {
  final int cycleNumber;
  final int registerX;
  int get signalStrength => cycleNumber * registerX;

  CPUSnapshot(this.cycleNumber, this.registerX);

  String drawPixel() {
    final pixelPosition = (cycleNumber - 1) % 40;
    if (pixelPosition >= registerX - 1 && pixelPosition <= registerX + 1) {
      return '#';
    }
    return '.';
  }
}

class CPU {
  int cycleNumber = 1;
  int registerX = 1;

  CPU();

  Iterable<CPUSnapshot> executeProgram(List<Instruction> instructions) sync* {
    int currentInstruction = 0;
    while (true) {
      yield CPUSnapshot(cycleNumber, registerX);
      if (currentInstruction < instructions.length) {
        if (instructions[currentInstruction].tick(this)) currentInstruction++;
      }
      cycleNumber++;
    }
  }

  String drawProgram(List<Instruction> instructions) {
    return executeProgram(instructions)
        .take(240)
        .map((cpu) => cpu.drawPixel())
        .slices(40)
        .map((row) => row.join(''))
        .join('\n');
  }
}

void main() {
  final input = File('inputs/10.txt').readAsLinesSync();

  final signalStrengthSum = CPU()
      .executeProgram(
        input.map((line) => Instruction.fromString(line)).toList(),
      )
      .take(220)
      .where((cpu) => [20, 60, 100, 140, 180, 220].contains(cpu.cycleNumber))
      .map((cpu) => cpu.signalStrength)
      .sum;

  print('The sum of the six notable signal strengths is $signalStrengthSum');

  print(CPU().drawProgram(
    input.map((line) => Instruction.fromString(line)).toList(),
  ));
}
