import 'dart:io' show Directory, File;

import 'package:path/path.dart' as path;

import 'animation_tools.dart';

class SpineAnimationTools extends AnimationTools {
  SpineAnimationTools(String sourcePath) : super(sourcePath);

  @override
  void copy(String destinationPath) {
    assert(destinationPath.isNotEmpty);

    final destination = Directory(destinationPath);
    print('\nCopying animation'
        ' from `${current.path}` to `${destination.path}`...');

    _copyWithRenameFiles(current, destination);

    print('Success copy animation'
        ' from `${current.path}` to `${destination.path}`.');
  }

  void _copyWithRenameFiles(Directory source, Directory destination) {
    final sourceFolder = path.basename(current.path);
    final destinationFolder = path.basename(destination.path);

    destination.createSync(recursive: true);
    current.listSync(recursive: false).forEach((final entity) {
      if (entity is Directory) {
        final p = '${destination.absolute.path}/${path.basename(entity.path)}';
        print('Directory `$p`');
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
        print('Renamed file `$pathToFile` -> `$p`');
        entity.copySync(p);
        return;
      }
    });
  }
}
