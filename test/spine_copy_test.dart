import 'dart:io' show Directory, File;

import 'package:animation_tools/spine/spine_animation_tools.dart';
import 'package:test/test.dart';

void main() async {
  const sourceFolder = 'owl';
  const sourcePath = 'test/data/$sourceFolder';
  const copyFolder = '${sourceFolder}_75';
  const copyPath = 'test/data/$copyFolder';

  final tools = SpineAnimationTools(sourcePath);
  await tools.copy(copyPath);

  test('SpineAnimationTools copy', () async {
    expect(Directory(copyPath).existsSync(), true);
    expect(File('$copyPath/$copyFolder.atlas').existsSync(), true);
    expect(File('$copyPath/$copyFolder.json').existsSync(), true);
    expect(File('$copyPath/$copyFolder.webp').existsSync(), true);

    final s = File('$copyPath/$copyFolder.atlas').readAsStringSync();
    expect(s.isNotEmpty, true);
    expect(s.contains('$copyFolder.webp'), true);
    expect(s.contains('$sourceFolder.webp'), false);
  });
}
