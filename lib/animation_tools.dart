import 'dart:io' show Directory;

import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;

/// Base class for tools.
abstract class AnimationTools {
  AnimationTools(String currentPath)
      : assert(currentPath.isNotEmpty),
        source = Directory(currentPath) {
    assert(source.existsSync());
    current = source;
  }

  /// Source directory.
  final Directory source;

  /// Current worked directory.
  late Directory current;

  /// See [source].
  String get sourceFolder => path.basename(source.path);

  /// See [source].
  String get sourcePath => source.path;

  /// See [current].
  String get currentFolder => path.basename(current.path);

  /// See [current].
  String get currentPath => current.path;

  /// Checks animation.
  Future<void> check();

  /// Copies animation.
  Future<void> copy(String destinationPath);

  /// Deletes animation.
  Future<void> delete();

  /// Leaves only [names] animation.
  Future<void> leaveAnimations(List<String> names);

  /// Moves  animation from [nameFrom] to [nameTo].
  Future<void> moveAnimation(String nameFrom, String nameTo);

  /// Removes animation with [name].
  Future<void> removeAnimation(String name);

  /// Scales animation.
  Future<void> scale(num scale);

  /// Indent for output.
  @protected
  String indent(int n) => (n > 0) ? '\t' * n : '';

  @protected
  int currentIndentValue = 1;

  @protected
  String get currentIndent => indent(currentIndentValue);

  @protected
  void resetCurrentIndent() => currentIndentValue = 1;

  @protected
  void increaseCurrentIndent() => ++currentIndentValue;

  @protected
  void decreaseCurrentIndent() => --currentIndentValue;
}
