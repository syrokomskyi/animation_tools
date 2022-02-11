import 'dart:io' show File;

import 'package:animation_tools/extensions/json_extension.dart';
import 'package:animation_tools/spine/spine_animation_tools.dart';
import 'package:image/image.dart';
import 'package:test/test.dart';

/// See inner classes tests into the `spine_texture_atlas_test.dart`.
void main() {
  test('SpineAnimationTools scale', () async {
    const sourcePath = 'test/data/owl_100';
    const expectedPath = 'test/data/owl_50_expected';
    const scale = 0.75;
    final tools = SpineAnimationTools(sourcePath);

    final sourceBytes = File('$sourcePath/owl_100.webp').readAsBytesSync();
    final sourceImage = decodeImage(sourceBytes)!;

    const copyPath = 'test/data/owl_50';
    await tools.copy(copyPath);
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
        final e = ExpectTest(
          json['skeleton'],
          ejson['skeleton'],
        );
        e.test('x');
        e.test('y');
        e.test('width');
        e.test('height');
      }

      {
        final e = ExpectTest(
          (json['bones'] as List)[1],
          (ejson['bones'] as List)[1],
        );
        e.test('length');
        e.test('rotation');
        e.test('x');
        e.test('y');
      }

      {
        final e = ExpectTest(
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
        final e = ExpectTest(
          (bone['rotate'] as List)[1],
          (ebone['rotate'] as List)[1],
        );
        e.test('time');
        e.test('angle');
      }
      {
        final e = ExpectTest(
          (bone['translate'] as List)[1],
          (ebone['translate'] as List)[1],
        );
        e.test('time');
        e.test('angle');
      }
    }

    // texture
    {
      final bytes = File(tools.pathToFileTexture).readAsBytesSync();
      final image = decodeImage(bytes)!;
      expect(image.width, (sourceImage.width * scale).round());
      expect(image.height, (sourceImage.height * scale).round());
    }
  });
}

class ExpectTest {
  final Map<String, dynamic> o;
  final Map<String, dynamic> eo;

  const ExpectTest(dynamic o, dynamic eo)
      : o = o as Map<String, dynamic>,
        eo = eo as Map<String, dynamic>;

  void test(String name) => expect(
        o[name],
        eo[name],
        reason: 'original\n${o.sjson}\nexpected\n${eo.sjson}',
      );
}
