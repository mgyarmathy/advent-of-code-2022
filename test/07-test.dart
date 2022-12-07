import 'package:advent_of_code_2022/07.dart';
import 'package:test/test.dart';

void main() {
  group(Directory, () {
    test(
        '#size is the sum of sizes of all files within the directory and any subdirectories',
        () {
      /*
      - / (dir)
        - a (dir)
          - e (dir)
            - i (file, size=584)
          - f (file, size=29116)
          - g (file, size=2557)
          - h.lst (file, size=62596)
        - b.txt (file, size=14848514)
        - c.dat (file, size=8504156)
        - d (dir)
          - j (file, size=4060174)
          - d.log (file, size=8033020)
          - d.ext (file, size=5626152)
          - k (file, size=7214296)
      */
      final root = Directory('/', files: [
        Directory('a', files: [
          Directory('e', files: [
            File('i', 584),
          ]),
          File('f', 29116),
          File('g', 2557),
          File('h.lst', 62596)
        ]),
        File('b.txt', 14848514),
        File('c.dat', 8504156),
        Directory('d', files: [
          File('j', 4060174),
          File('d.log', 8033020),
          File('d.ext', 5626152),
          File('k', 7214296),
        ]),
      ]);

      expect(root.size, 48381165);
    });
  });

  group(LazyFileSystem, () {
    test('initializes as an empty file system', () {
      final fs = LazyFileSystem();
      expect(fs.usedSpace, 0);
      expect(fs.allDirectories, [fs.rootDirectory]);
      expect(fs.pwd.name, '/');
    });
    test('is populated as you list it\'s contents', () {
      final fs = LazyFileSystem();

      fs.ls(['dir a', '14848514 b.txt', '8504156 c.dat', 'dir d']);
      expect(fs.usedSpace, 14848514 + 8504156);
      expect(fs.allDirectories.map((dir) => dir.name), ['/', 'a', 'd']);

      fs.cd('a');
      fs.ls(['dir e', '29116 f', '2557 g', '62596 h.lst']);
      expect(fs.usedSpace, 14848514 + 8504156 + 29116 + 2557 + 62596);
      expect(fs.allDirectories.map((dir) => dir.name), ['/', 'a', 'd', 'e']);
    });
    test(
        '.fromTerminalOutput replays terminal output to build the contents of the file system',
        () {
      final fs = LazyFileSystem.fromTerminalOutput(
        r'''$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k''',
      );
      expect(fs.usedSpace, 48381165);
    });
  });
}
