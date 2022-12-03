import 'package:test/test.dart';
import 'package:advent_of_code_2022/02.dart';

void main() {
  test(
      'Round#score is the sum of the value of the player\'s shape plus the value of the outcome of the round',
      () {
    expect(Round(HandShape.Paper, HandShape.Rock).score, 8);
    expect(Round(HandShape.Rock, HandShape.Paper).score, 1);
    expect(Round(HandShape.Scissors, HandShape.Scissors).score, 6);
  });

  test('Round.forOutcome sets the player guess for a fixed outcome', () {
    expect(
      Round.forOutcome(RoundOutcome.Draw, HandShape.Rock).player,
      HandShape.Rock,
    );
    expect(
      Round.forOutcome(RoundOutcome.Win, HandShape.Rock).player,
      HandShape.Paper,
    );
    expect(
      Round.forOutcome(RoundOutcome.Loss, HandShape.Rock).player,
      HandShape.Scissors,
    );
  });
}
