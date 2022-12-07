import 'package:advent_of_code_2022/06.dart';
import 'package:test/test.dart';

void main() {
  test('detectStartOfPacket()', () {
    expect(detectStartOfPacket('bvwbjplbgvbhsrlpgdmjqwftvncz'), 5);
    expect(detectStartOfPacket('nppdvjthqldpwncqszvftbrmjlhg'), 6);
    expect(detectStartOfPacket('nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg'), 10);
    expect(detectStartOfPacket('zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw'), 11);
  });
  test('detectStartOfMessage()', () {
    expect(detectStartOfMessage('mjqjpqmgbljsphdztnvjfqwrcgsmlb'), 19);
    expect(detectStartOfMessage('bvwbjplbgvbhsrlpgdmjqwftvncz'), 23);
    expect(detectStartOfMessage('nppdvjthqldpwncqszvftbrmjlhg'), 23);
    expect(detectStartOfMessage('nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg'), 29);
    expect(detectStartOfMessage('zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw'), 26);
  });
}
