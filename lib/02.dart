import 'dart:io';
import 'package:collection/collection.dart';
import 'package:quiver/collection.dart';

enum HandShape {
  Rock(1),
  Paper(2),
  Scissors(3);

  final int value;

  const HandShape(this.value);

  factory HandShape.fromString(String s) {
    switch (s) {
      case "A":
      case "X":
        return Rock;
      case "B":
      case "Y":
        return Paper;
      case "C":
      case "Z":
        return Scissors;
    }
    throw UnimplementedError("Unable to parse HandShape for $s");
  }
}

enum RoundOutcome {
  Loss(0),
  Draw(3),
  Win(6);

  final int value;

  const RoundOutcome(this.value);

  factory RoundOutcome.fromString(String s) {
    switch (s) {
      case "X":
        return Loss;
      case "Y":
        return Draw;
      case "Z":
        return Win;
    }
    throw UnimplementedError("Unable to parse RoundOutcome for $s");
  }
}

class Round {
  static final BiMap<HandShape, HandShape> winConditions = new BiMap()
    ..addAll({
      HandShape.Rock: HandShape.Scissors,
      HandShape.Scissors: HandShape.Paper,
      HandShape.Paper: HandShape.Rock,
    });

  final HandShape player;
  final HandShape opponent;

  const Round(this.player, this.opponent);

  factory Round.forOutcome(RoundOutcome outcome, HandShape opponent) {
    switch (outcome) {
      case RoundOutcome.Loss:
        return Round(winConditions[opponent]!, opponent);
      case RoundOutcome.Draw:
        return Round(opponent, opponent);
      case RoundOutcome.Win:
        return Round(winConditions.inverse[opponent]!, opponent);
    }
  }

  RoundOutcome get outcome {
    if (player == opponent) return RoundOutcome.Draw;

    return winConditions[player] == opponent
        ? RoundOutcome.Win
        : RoundOutcome.Loss;
  }

  int get score => player.value + outcome.value;
}

void main() {
  final input = new File('inputs/02.txt').readAsLinesSync();

  // Part 1
  final roundsBasedOnPlayerGuesses = input.map((s) {
    final players = s.split(' ').map((e) => HandShape.fromString(e)).toList();
    final player = players.elementAt(1);
    final opponent = players.elementAt(0);
    return Round(player, opponent);
  });
  final totalScoreBasedOnPlayerGuesses =
      roundsBasedOnPlayerGuesses.map((r) => r.score).sum;

  print(
    'The total score based on player guesses is $totalScoreBasedOnPlayerGuesses',
  );

  // Part 2
  final roundsBasedOnFixedOutcome = input.map((s) {
    final outcome = RoundOutcome.fromString(s.split(' ')[1]);
    final opponent = HandShape.fromString(s.split(' ')[0]);
    return Round.forOutcome(outcome, opponent);
  });
  final totalScoreBasedOnFixedOutcome =
      roundsBasedOnFixedOutcome.map((r) => r.score).sum;

  print(
    'The total score based on fixed outcomes $totalScoreBasedOnFixedOutcome',
  );
}
