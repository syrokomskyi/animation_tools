import 'package:animation_tools/spine/spine_texture_atlas.dart';
import 'package:test/test.dart';

void main() {
  test('SpineTextureAtlas XY.scale', () async {
    const source = '  xy: 2, 690';
    final line = XY(source);

    line.scale(0.75);
    expect(line.toString(), '  xy: 2, 518');
  });

  test('SpineTextureAtlas Size.scale without spaces', () async {
    const source = 'size: 1108, 836';
    final line = Size(source);

    line.scale(0.755);
    expect(line.toString(), 'size: 837, 631');
  });
}
