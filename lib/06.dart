import 'dart:io';

int _detectDistinctCharacterSequence(String s, int size) {
  for (int i = 0; i < s.length - size; i++) {
    if (s.substring(i, i + size).split('').toSet().length == size) {
      return i + size;
    }
  }
  return -1;
}

int detectStartOfPacket(String s) => _detectDistinctCharacterSequence(s, 4);
int detectStartOfMessage(String s) => _detectDistinctCharacterSequence(s, 14);

void main() {
  final input = new File('inputs/06.txt').readAsStringSync();
  print(
    'Start-of-packet marker detected after ${detectStartOfPacket(input)} characters',
  );
  print(
    'Start-of-message marker detected after ${detectStartOfMessage(input)} characters',
  );
}
