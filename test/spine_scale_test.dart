import 'dart:io' show Directory, File;

import 'package:animation_tools/extensions/json_extension.dart';
import 'package:animation_tools/spine/spine_animation_tools.dart';
import 'package:image/image.dart';
import 'package:test/test.dart';

import 'expect_json_helper.dart';

/// See inner classes tests into the `spine_texture_atlas_test.dart`.
void main() async {
  const sourceFolder = 'owl';
  const sourcePath = 'test/data/$sourceFolder';

  final tempPath = Directory.systemTemp.createTempSync().path;
  const expectedFolder = '${sourceFolder}_75_expected';
  const expectedPath = 'test/data/$expectedFolder';
  const scale = 0.75;

  const copyFolder = '${sourceFolder}_75';
  final copyPath = '$tempPath/test/data/$copyFolder';
  final tools = SpineAnimationTools(sourcePath);
  await tools.copy(copyPath);

  test('SpineAnimationTools scale', () async {
    await tools.scale(scale);

    // atlas
    {
      final s = File(tools.pathToFileAtlas).readAsStringSync();
      final es = File('$expectedPath/${tools.fileAtlas}').readAsStringSync();
      expect(s, es);
    }

    // skeleton
    {
      final json = File(tools.pathToFileSkeleton).readAsStringSync().jsonMap;
      final ejson = File('$expectedPath/${tools.fileSkeleton}')
          .readAsStringSync()
          .jsonMap;

      {
        final e = ExpectJsonHelper(
          json['skeleton'],
          ejson['skeleton'],
        );
        e.test('x');
        e.test('y');
        e.test('width');
        e.test('height');
      }

      {
        final e = ExpectJsonHelper(
          (json['bones'] as List)[1],
          (ejson['bones'] as List)[1],
        );
        e.test('length');
        e.test('rotation');
        e.test('x');
        e.test('y');
      }

      {
        final e = ExpectJsonHelper(
          (json['transform'] as List)[0],
          (ejson['transform'] as List)[0],
        );
        e.test('rotation');
        e.test('x');
        e.test('y');
        e.test('shearY');
        e.test('translateMix');
        e.test('scaleMix');
        e.test('shearMix');
      }

      final bone =
          // ignore: avoid_dynamic_calls
          json['animations']['idle']['bones']['bone'] as Map<String, dynamic>;
      final ebone =
          // ignore: avoid_dynamic_calls
          ejson['animations']['idle']['bones']['bone'] as Map<String, dynamic>;
      {
        final e = ExpectJsonHelper(
          (bone['rotate'] as List)[1],
          (ebone['rotate'] as List)[1],
        );
        e.test('time');
        e.test('angle');
      }
      {
        final e = ExpectJsonHelper(
          (bone['translate'] as List)[1],
          (ebone['translate'] as List)[1],
        );
        e.test('time');
        e.test('angle');
      }
    }

    // texture
    {
      final sourceBytes =
          File('$sourcePath/$sourceFolder.webp').readAsBytesSync();
      final sourceImage = decodeImage(sourceBytes)!;

      final bytes = File(tools.pathToFileTexture).readAsBytesSync();
      final image = decodeImage(bytes)!;
      expect(image.width, (sourceImage.width * scale).round());
      expect(image.height, (sourceImage.height * scale).round());
    }
  });
}
