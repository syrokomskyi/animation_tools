import 'dart:io' show Directory;

import 'package:path/path.dart' as path;

abstract class AnimationTools {
  final Directory source;

  late Directory current;

  String get sourceFolder => path.basename(source.path);

  String get currentFolder => path.basename(current.path);

  AnimationTools(String currentPath)
      : assert(currentPath.isNotEmpty),
        source = Directory(currentPath) {
    assert(source.existsSync());
    current = source;
  }

  Future<void> copy(String destinationPath);
}
