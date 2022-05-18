import 'dart:io' show Directory, File;

import 'package:image/image.dart';
import 'package:path/path.dart' as path;

import '../animation_tools.dart';
import 'spine_skeleton_json.dart';
import 'spine_texture_atlas.dart';

class SpineAnimationTools extends AnimationTools {
  SpineAnimationTools(super.sourcePath);

  String get fileAtlas => buildFileNameAtlas(currentFolder);

  String get pathToFileAtlas => '$currentPath/$fileAtlas';

  String get fileSkeleton => buildFileNameSkeleton(currentFolder);

  String get pathToFileSkeleton => '$currentPath/$fileSkeleton';

  String get fileTexture => buildFileNameTexture(currentFolder);

  String get pathToFileTexture => '$currentPath/$fileTexture';

  static String buildFileNameAtlas(String name) => '$name.atlas';

  static String buildFileNameSkeleton(String name) => '$name.json';

  static String buildFileNameTexture(String name) => '$name.webp';

  @override
  Future<void> check() async {
    print('\n--check'
        '\n\tsource: `$sourcePath`'
        '\n');

    // 1) Checking availability files.
    var step = 1;
    resetCurrentIndent();
    {
      print('$currentIndent$step) Checking availability files'
          ' for animation `${current.path}`...');
      if (!File(pathToFileAtlas).existsSync()) {
        throw Exception('Atlas not found by path `$pathToFileAtlas`.');
      }

      if (!File(pathToFileSkeleton).existsSync()) {
        throw Exception('Skeleton not found by path `$pathToFileSkeleton`.');
      }

      if (!File(pathToFileTexture).existsSync()) {
        throw Exception('Texture not found by path `$pathToFileTexture`.');
      }

      print('$currentIndent\tSuccess check availability'
          ' for animation `${current.path}`.');
    }

    // 2) Checking reference.
    ++step;
    resetCurrentIndent();
    {
      print('$currentIndent$step) Checking reference to texture'
          ' for animation `${current.path}`...');

      final textureAtlas = SpineTextureAtlas(File(pathToFileAtlas));
      if (!textureAtlas.hasReferenceToTexture(fileTexture)) {
        throw Exception('Reference to texture `$fileTexture`'
            ' not found into the file `$pathToFileAtlas`.');
      }

      print('$currentIndent\tSuccess check reference to texture'
          ' for animation `${current.path}`.');
    }
  }

  @override
  Future<void> copy(String destinationPath) async {
    assert(destinationPath.isNotEmpty);

    print('\n--copy'
        '\n\tsource: `$sourcePath`'
        '\n\tdestinationPath: `$destinationPath`'
        '\n');

    final destination = Directory(destinationPath);

    // 1) Clear destination path.
    var step = 1;
    resetCurrentIndent();
    {
      print('$currentIndent$step) Clearing destination path'
          ' `${destination.path}`...');
      if (destination.existsSync()) {
        destination.deleteSync(recursive: true);
      }
      print('$currentIndent\tSuccess clear destination path'
          ' `${destination.path}`.');
    }

    // 2) Copy files.
    ++step;
    resetCurrentIndent();
    {
      print('$currentIndent$step) Copying animation'
          ' from `${current.path}` to `${destination.path}`...');
      increaseCurrentIndent();
      _copyWithRenameFiles(current, destination);
      decreaseCurrentIndent();
      current = destination;
      print('$currentIndent\tSuccess copy animation'
          ' from `${current.path}` to `${destination.path}`.');
    }

    // 3) Rename dependencies into the file [fileAtlas].
    ++step;
    resetCurrentIndent();
    {
      final p = '${current.path}/$fileAtlas';
      print('$currentIndent$step) Renaming dependencies into the file `$p`...');
      final oldFilePattern = buildFileNameTexture(sourceFolder);
      final newFilePattern = buildFileNameTexture(currentFolder);
      final file = File(p);
      increaseCurrentIndent();
      _renameContentFile(file, oldFilePattern, newFilePattern);
      decreaseCurrentIndent();
      print('$currentIndent\tSuccess rename dependencies into the file `$p`.');
    }
  }

  @override
  Future<void> delete() async {
    print('\n--delete'
        '\n\tsource: `$sourcePath`'
        '\n');

    // 1) Delete files.
    const step = 1;
    resetCurrentIndent();
    {
      print('$currentIndent$step) Deleting animation'
          ' by path `${current.path}`...');
      if (current.existsSync()) {
        current.delete(recursive: true);
      }
      print('$currentIndent\tSuccess delete animation'
          ' by path `${current.path}`.');
    }
  }

  @override
  Future<void> leaveAnimations(List<String> names) async {
    assert(names.isNotEmpty);

    print('\n--leave_animations'
        '\n\tsource: `$sourcePath`'
        '\n\tnames: $names'
        '\n');

    // 1) Search animations.
    var step = 1;
    resetCurrentIndent();
    late final Map<String, dynamic> animations;
    {
      final p = pathToFileSkeleton;
      print('$currentIndent$step) Searching animations $names'
          ' into the `$p`...');

      final file = File(p);
      final skeleton = SpineSkeletonJson(file);
      animations = (skeleton.json['animations'] ?? <String, dynamic>{})
          as Map<String, dynamic>;
      String? notFoundName;
      for (final name in names) {
        assert(name.trim() == name);
        if (animations[name] == null) {
          notFoundName = name;
          break;
        }
      }

      if (notFoundName != null) {
        print('$currentIndent\tAnimation `$notFoundName` not found'
            ' into the `$p`.');
        return;
      }

      print('$currentIndent\tAll animations - $names -'
          ' found into the `$p`.');
    }

    // 2) Leave only animations.
    ++step;
    resetCurrentIndent();
    {
      final p = pathToFileSkeleton;
      print('$currentIndent$step) Leave only animations $names'
          ' into the `$p`...');

      final file = File(p);
      final skeleton = SpineSkeletonJson(file);
      final kept = skeleton.leaveAnimations(names);
      skeleton.save(kept);

      print('$currentIndent\tOnly animations $names'
          ' are kept into the `$p`.');
    }
  }

  @override
  Future<void> moveAnimation(String nameFrom, String nameTo) async {
    assert(nameFrom.isNotEmpty);
    assert(nameTo.isNotEmpty);

    print('\n--move_animation'
        '\n\tsource: `$sourcePath`'
        '\n\tnameFrom: $nameFrom'
        '\n\tnameTo: $nameTo'
        '\n');

    // 1) Search animation.
    var step = 1;
    resetCurrentIndent();
    late final Map<String, dynamic> animations;
    {
      final p = pathToFileSkeleton;
      print(
          '$currentIndent$step) Searching animation `$nameFrom` into the `$p`...');

      final file = File(p);
      final skeleton = SpineSkeletonJson(file);
      animations = (skeleton.json['animations'] ?? <String, dynamic>{})
          as Map<String, dynamic>;

      if (animations.isEmpty) {
        print('$currentIndent\tAnimation `$nameFrom` not found into the `$p`.');
        return;
      }

      print('$currentIndent\tAnimation `$nameFrom` found into the `$p`.');
    }

    // 2) Move animation.
    ++step;
    resetCurrentIndent();
    {
      final p = pathToFileSkeleton;
      print('$currentIndent$step) Moving animation `$nameFrom`'
          ' to `$nameTo` into the `$p`...');

      final file = File(p);
      final skeleton = SpineSkeletonJson(file);
      final moved = skeleton.moveAnimation(nameFrom, nameTo);
      skeleton.save(moved);

      print('$currentIndent\tAnimation `$nameFrom` moved'
          ' to `$nameFrom` into the `$p`.');
    }
  }

  @override
  Future<void> removeAnimation(String name) async {
    assert(name.isNotEmpty);

    print('\n--remove_animation'
        '\n\tsource: `$sourcePath`'
        '\n\tname: $name'
        '\n');

    // 1) Search animation.
    var step = 1;
    resetCurrentIndent();
    late final Map<String, dynamic> animations;
    {
      final p = pathToFileSkeleton;
      print(
          '$currentIndent$step) Searching animation `$name` into the `$p`...');

      final file = File(p);
      final skeleton = SpineSkeletonJson(file);
      animations = (skeleton.json['animations'] ?? <String, dynamic>{})
          as Map<String, dynamic>;

      if (animations.isEmpty) {
        print('$currentIndent\tAnimation `$name` not found into the `$p`.');
        return;
      }

      print('$currentIndent\tAnimation `$name` found into the `$p`.');
    }

    // 2) Remove animation.
    ++step;
    resetCurrentIndent();
    {
      final p = pathToFileSkeleton;
      print('$currentIndent$step) Removing animation `$name` from the `$p`...');

      final file = File(p);
      final skeleton = SpineSkeletonJson(file);
      final removed = skeleton.removeAnimation(name);
      skeleton.save(removed);

      print('$currentIndent\tAnimation `$name` removed from the `$p`.');
    }
  }

  @override
  Future<void> scale(num scale) async {
    assert(scale > 0);

    print('\n--scale'
        '\n\tsource: `$sourcePath`'
        '\n\tscale: $scale'
        '\n');

    // 1) Scale texture.
    var step = 1;
    resetCurrentIndent();
    {
      final p = pathToFileTexture;
      print('$currentIndent$step) Scaling texture `$p` to $scale...');

      final file = File(p);
      final bytes = file.readAsBytesSync();
      final image = decodeImage(bytes)!;
      final width = image.width * scale;
      final height = image.height * scale;
      final scaled = copyResize(
        image,
        width: width.toInt(),
        height: height.toInt(),
        interpolation: Interpolation.nearest,
      );

      final encoded = encodePng(scaled);
      file.writeAsBytesSync(encoded, flush: true);

      /* \todo Add a compress to WEBP format.
      \see https://pub.dev/packages/flutter_image_compress
      final compressed = await FlutterImageCompress.compressWithList(
        image.getBytes(),
        minWidth: width.toInt(),
        minHeight: height.toInt(),
        quality: 100,
        format: CompressFormat.webp,
        keepExif: true,
      );
      file.writeAsBytesSync(compressed, flush: true);
      */

      print('$currentIndent\tSuccess scaling texture `$p` to $scale.');
    }

    // 2) Scale atlas.
    ++step;
    resetCurrentIndent();
    {
      final p = pathToFileAtlas;
      print('$currentIndent$step) Scaling atlas `$p` to $scale...');

      final file = File(p);
      final textureAtlas = SpineTextureAtlas(file);
      textureAtlas.scaleAndSave(scale);

      print('$currentIndent\tSuccess scaling atlas `$p` to $scale.');
    }

    // 3) Scale skeleton.
    ++step;
    resetCurrentIndent();
    {
      final p = pathToFileSkeleton;
      print('$currentIndent$step) Scaling skeleton `$p` to $scale...');

      final file = File(p);
      final skeleton = SpineSkeletonJson(file);
      final scaled = skeleton.scale(scale);
      skeleton.save(scaled);

      print('$currentIndent\tSuccess scaling skeleton `$p` to $scale.');
    }
  }

  void _copyWithRenameFiles(Directory source, Directory destination) {
    final destinationFolder = path.basename(destination.path);

    destination.createSync(recursive: true);
    current.listSync(recursive: false).forEach((final entity) {
      if (entity is Directory) {
        final p = '${destination.absolute.path}/${path.basename(entity.path)}';
        print('${currentIndent}Directory `$p`');
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
        print('${currentIndent}Renamed file `$pathToFile` -> `$p`');
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
