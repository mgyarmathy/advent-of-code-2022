import 'dart:io' as io;
import 'package:collection/collection.dart';
import 'package:advent_of_code_2022/05.dart' show Stack;

class File {
  final String name;
  final int size;

  const File(this.name, this.size);

  factory File.fromString(String s) {
    String size = s.split(' ')[0];
    String name = s.split(' ')[1];
    if (size == 'dir') {
      return Directory(name);
    }
    return File(name, int.parse(size));
  }
}

class Directory implements File {
  final String name;
  final List<File> files;

  Directory(this.name, {List<File>? files}) : files = List.from(files ?? []);

  Iterable<Directory> get subdirectories {
    return [
      ...files.whereType<Directory>(),
      ...files.whereType<Directory>().expand((dir) => dir.subdirectories)
    ];
  }

  @override
  int get size => files.map((f) => f.size).sum;
}

class LazyFileSystem {
  final totalSpace = 70000000;
  final rootDirectory = Directory('/');
  final wd = Stack<Directory>();

  LazyFileSystem() {
    wd.push(rootDirectory);
  }

  factory LazyFileSystem.fromTerminalOutput(String output) {
    final fs = LazyFileSystem();
    final commands = output.split(new RegExp(r'\n?\$ ')).skip(1);
    commands.forEach((command) => fs._replayTerminalOutput(command));
    return fs;
  }

  void _replayTerminalOutput(String output) {
    final lines = output.split('\n');
    final command = lines.first;
    final result = lines.skip(1);
    if (command.startsWith('cd')) {
      final destination = command.split(' ').last;
      cd(destination);
    } else if (command == 'ls') {
      ls(result);
    } else {
      throw UnimplementedError('unknown command: $command');
    }
  }

  void cd(String destination) {
    if (destination == '/') {
      while (wd.peek != null) wd.pop();
      wd.push(rootDirectory);
    } else if (destination == '..') {
      if (wd.size > 1) wd.pop();
    } else {
      try {
        wd.push(
          pwd.files.firstWhere(
            (file) => file is Directory && file.name == destination,
          ) as Directory,
        );
      } on StateError {
        print('No such file or directory');
      }
    }
  }

  void ls(Iterable<String> result) {
    if (pwd.files.isNotEmpty) return;
    final files = result.map((line) => File.fromString(line));
    pwd.files.addAll(files);
  }

  Directory get pwd => wd.peek!;

  Iterable<Directory> get allDirectories => [
        rootDirectory,
        ...rootDirectory.subdirectories,
      ];

  int get usedSpace => rootDirectory.size;
  int get availableSpace => totalSpace - usedSpace;
}

void main() {
  final input = io.File('inputs/07.txt').readAsStringSync();

  final fs = LazyFileSystem.fromTerminalOutput(input);

  final largeDirectoriesForDeletion =
      fs.allDirectories.where((dir) => dir.size < 100000);

  print(
    'The sum of the sizes of all directories to be deleted is ${largeDirectoriesForDeletion.map((dir) => dir.size).sum}',
  );

  final updateFileSize = 30000000;
  final spaceNeededToClear = updateFileSize - fs.availableSpace;
  final directoryToDelete = fs.allDirectories
      .sorted((a, b) => a.size - b.size)
      .firstWhere((dir) => dir.size > spaceNeededToClear);

  print(
    'In order to make room for the update, we should delete directory ${directoryToDelete.name}, which is of size ${directoryToDelete.size}',
  );
}
