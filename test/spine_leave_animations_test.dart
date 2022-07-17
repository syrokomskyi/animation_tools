import 'dart:io';

import 'package:animation_tools/spine/spine_animation_tools.dart';
import 'package:animation_tools/spine/spine_skeleton_json.dart';
import 'package:test/test.dart';

import 'expect_json_helper.dart';

void main() async {
  const sourceFolder = 'spineboy';
  const sourcePath = 'test/data/$sourceFolder';

  final tempPath = Directory.systemTemp.createTempSync().path;
  const expectedFolder = '${sourceFolder}_leave_animations_expected';
  const expectedPath = 'test/data/$expectedFolder';
  const animations = <String>['walk', 'idle', 'run'];

  const copyFolder = '${sourceFolder}_leave_animations';
  final copyPath = '$tempPath/test/data/$copyFolder';
  final tools = SpineAnimationTools(sourcePath);
  await tools.copy(copyPath);

  test('SpineAnimationTools leave_animations', () async {
    await tools.leaveAnimations(animations);

    final json = SpineSkeletonJson.path(tools.pathToFileSkeleton).json;
    final ejson =
        SpineSkeletonJson.path('$expectedPath/${tools.fileSkeleton}').json;

    final e = ExpectJsonHelper(json, ejson);
    e.test('animations');
    e.test('');
  });
}
