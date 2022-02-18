import 'package:animation_tools/spine/spine_animation_tools.dart';
import 'package:animation_tools/spine/spine_skeleton_json.dart';
import 'package:test/test.dart';

import 'expect_json_helper.dart';

void main() {
  test('SpineAnimationTools leave_animations', () async {
    const sourceFolder = 'spineboy';
    const sourcePath = 'test/data/$sourceFolder';
    const expectedFolder = 'spineboy_leave_animations_expected';
    const expectedPath = 'test/data/$expectedFolder';
    const animations = <String>['walk', 'idle', 'run'];

    const copyFolder = 'spineboy_leave_animations';
    const copyPath = 'test/data/$copyFolder';
    final tools = SpineAnimationTools(sourcePath);
    await tools.copy(copyPath);

    await tools.leaveAnimations(animations);

    final json = SpineSkeletonJson.path(tools.pathToFileSkeleton).json;
    final ejson =
        SpineSkeletonJson.path('$expectedPath/${tools.fileSkeleton}').json;

    final e = ExpectJsonHelper(json, ejson);
    e.test('animations');
    e.test('');
  });
}
