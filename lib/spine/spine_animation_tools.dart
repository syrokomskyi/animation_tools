import 'dart:io' show Directory, File;

import 'package:path/path.dart' as path;

import '../animation_tools.dart';

class SpineAnimationTools extends AnimationTools {
  SpineAnimationTools(String sourcePath) : super(sourcePath);

  String get fileAtlas => '$currentFolder.atlas';

  String get fileJson => '$currentFolder.json';

  String get fileTexture => '$currentFolder.webp';

  @override
  Future<void> copy(String destinationPath) async {
    assert(destinationPath.isNotEmpty);

    print('\n');

    // 1) Copy files.
    {
      final destination = Directory(destinationPath);
      print('1) Copying animation'
          ' from `${current.path}` to `${destination.path}`...');
      _copyWithRenameFiles(current, destination);
      current = destination;
      print('\tSuccess copy animation'
          ' from `${current.path}` to `${destination.path}`.');
    }

    // 2) Rename dependencies into the file `*.atlas`.
    {
      final p = '${current.path}/$fileAtlas';
      print('2) Renaming dependencies into the file `$p`...');
      final oldFileName = sourceFolder;
      final newFileName = currentFolder;
      final file = File(p);
      _renameContentFile(file, oldFileName, newFileName);
      print('\tSuccess rename dependencies into the file `$p`...');
    }
  }

  void _copyWithRenameFiles(Directory source, Directory destination) {
    final destinationFolder = path.basename(destination.path);

    destination.createSync(recursive: true);
    current.listSync(recursive: false).forEach((final entity) {
      if (entity is Directory) {
        final p = '${destination.absolute.path}/${path.basename(entity.path)}';
        print('\tDirectory `$p`');
        final newDir = Directory(p);
        newDir.createSync();
        _copyWithRenameFiles(entity.absolute, newDir);
        return;
      }

      if (entity is File) {
        // replace just for uniform output to console
        final pathToFile = entity.path.replaceAll('\\', '/');
        final basename = path.basename(pathToFile);
        final renamedBasename =
            basename.replaceFirst(sourceFolder, destinationFolder);
        final p = '${destination.path}/$renamedBasename';
        print('\tRenamed file `$pathToFile` -> `$p`');
        entity.copySync(p);
        return;
      }
    });
  }

  void _renameContentFile(
    File file,
    Pattern from,
    String replace,
  ) {
    assert(file.existsSync());

    final s = file.readAsStringSync();
    final ps = s.replaceAll(from, replace);
    file.writeAsStringSync(ps, flush: true);
  }
}
