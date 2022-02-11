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

  test('SpineTextureAtlas Size.scale with spaces', () async {
    const source = '  size: 1108, 836';
    final line = Size(source);

    line.scale(0.755);
    expect(line.toString(), '  size: 837, 631');
  });

  test('SpineTextureAtlas Orig.scale', () async {
    const source = '  orig: 122, 143';
    final line = Orig(source);

    line.scale(0.75);
    expect(line.toString(), '  orig: 92, 107');
  });

  test('SpineTextureAtlas Orig.scale', () async {
    const source = '  offset: 2, 3';
    final line = Offset(source);

    line.scale(0.75);
    expect(line.toString(), '  offset: 2, 2');
  });
}
