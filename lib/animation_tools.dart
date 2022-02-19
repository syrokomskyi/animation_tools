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

  Future<void> delete();

  Future<void> leaveAnimations(List<String> names);

  Future<void> moveAnimation(String nameFrom, String nameTo);

  Future<void> removeAnimation(String name);

  Future<void> scale(num scale);

  String indent(int n) => (n > 0) ? '\t' * n : '';

  int currentIndentValue = 1;

  String get currentIndent => indent(currentIndentValue);

  void resetCurrentIndent() => currentIndentValue = 1;

  void increaseCurrentIndent() => ++currentIndentValue;

  void decreaseCurrentIndent() => --currentIndentValue;
}
