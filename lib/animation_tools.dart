import 'dart:io' show Directory;

abstract class AnimationTools {
  Directory current;

  AnimationTools(String currentPath)
      : assert(currentPath.isNotEmpty),
        current = Directory(currentPath) {
    assert(current.existsSync());
  }

  void copy(String destinationPath);
}
