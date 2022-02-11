import 'dart:io' show Directory, File;

import 'package:image/image.dart';
import 'package:path/path.dart' as path;

import '../animation_tools.dart';
import 'spine_skeleton_json.dart';
import 'spine_texture_atlas.dart';

class SpineAnimationTools extends AnimationTools {
  SpineAnimationTools(String sourcePath) : super(sourcePath);

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
    print('\n');

    // 1) Checking availability files.
    {
      print('1) Checking availability files'
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

      print('\tSuccess check availability'
          ' for animation `${current.path}`.');
    }

    // 2) Checking reference.
    {
      print('2) Checking reference to texture'
          ' for animation `${current.path}`...');

      final textureAtlas = SpineTextureAtlas(File(pathToFileAtlas));
      if (!textureAtlas.hasReferenceToTexture(fileTexture)) {
        throw Exception('Reference to texture `$fileTexture`'
            ' not found into the file `$pathToFileAtlas`.');
      }

      print('\tSuccess check reference to texture'
          ' for animation `${current.path}`.');
    }
  }

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

    // 2) Rename dependencies into the file [fileAtlas].
    {
      final p = '${current.path}/$fileAtlas';
      print('2) Renaming dependencies into the file `$p`...');
      final oldFilePattern = buildFileNameTexture(sourceFolder);
      final newFilePattern = buildFileNameTexture(currentFolder);
      final file = File(p);
      _renameContentFile(file, oldFilePattern, newFilePattern);
      print('\tSuccess rename dependencies into the file `$p`.');
    }
  }

  @override
  Future<void> scale(num scale) async {
    assert(scale > 0);

    print('\n');

    // 1) Scale texture.
    {
      final p = pathToFileTexture;
      print('1) Scaling texture `$p` to $scale...');

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

      print('\tSuccess scaling texture `$p` to $scale.');
    }

    // 2) Scale atlas.
    {
      final p = pathToFileAtlas;
      print('2) Scaling atlas `$p` to $scale...');

      final file = File(p);
      final textureAtlas = SpineTextureAtlas(file);
      textureAtlas.scaleAndSave(scale);

      print('\tSuccess scaling atlas `$p` to $scale.');
    }

    // 3) Scale skeleton.
    {
      final p = pathToFileSkeleton;
      print('3) Scaling skeleton `$p` to $scale...');

      final file = File(p);
      final skeleton = SpineSkeletonJson(file);
      skeleton.scaleAndSave(scale);

      print('\tSuccess scaling skeleton `$p` to $scale.');
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
