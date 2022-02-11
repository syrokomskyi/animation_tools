import 'dart:io' show Directory;

import 'package:path/path.dart' as path;

abstract class AnimationTools {
  final Directory source;

  late Directory current;

  String get sourceFolder => path.basename(source.path);

  String get sourcePath => source.path;

  String get currentFolder => path.basename(current.path);

  String get currentPath => current.path;

  AnimationTools(String currentPath)
      : assert(currentPath.isNotEmpty),
        source = Directory(currentPath) {
    assert(source.existsSync());
    current = source;
  }

  Future<void> check();

  Future<void> copy(String destinationPath);

  Future<void> scale(num scale);
}
