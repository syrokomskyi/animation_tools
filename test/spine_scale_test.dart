import 'dart:io' show Directory, File;

import 'package:animation_tools/spine/spine_animation_tools.dart';
import 'package:image/image.dart';
import 'package:test/test.dart';

/// See inner classes tests into the `spine_texture_atlas_test.dart`.
void main() {
  test('SpineAnimationTools scale', () async {
    const sourcePath = 'test/data/owl_100';
    const expectedPath = 'test/data/owl_50_expected';
    final tools = SpineAnimationTools(sourcePath);

    final sourceBytes = File('$sourcePath/owl_100.webp').readAsBytesSync();
    final sourceImage = decodeImage(sourceBytes)!;

    const copyPath = 'test/data/owl_50';
    await tools.copy(copyPath);
    await tools.scale(0.5);

    // atlas
    final s = File(tools.pathToFileAtlas).readAsStringSync();
    final se = File('$expectedPath/${tools.fileAtlas}').readAsStringSync();
    expect(s, se);

    // \TODO json

    // texture
    final bytes = File(tools.pathToFileTexture).readAsBytesSync();
    final image = decodeImage(bytes)!;
    expect(image.width, sourceImage.width / 2);
    expect(image.height, sourceImage.height / 2);
  });
}
