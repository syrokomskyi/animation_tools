import 'package:animation_tools/spine/spine_animation_tools.dart';
import 'package:animation_tools/spine/spine_skeleton_json.dart';
import 'package:test/test.dart';

import 'expect_json_helper.dart';

void main() {
  test('SpineAnimationTools remove_animation', () async {
    const sourceFolder = 'owl_100';
    const sourcePath = 'test/data/$sourceFolder';
    const expectedFolder = 'owl_remove_animation_expected';
    const expectedPath = 'test/data/$expectedFolder';
    const animationForRemove = 'idle';

    const copyFolder = 'owl_remove_animation';
    const copyPath = 'test/data/$copyFolder';
    final tools = SpineAnimationTools(sourcePath);
    await tools.copy(copyPath);

    await tools.removeAnimation(animationForRemove);

    final json = SpineSkeletonJson.path(tools.pathToFileSkeleton).json;
    final ejson =
        SpineSkeletonJson.path('$expectedPath/${tools.fileSkeleton}').json;

    final e = ExpectJsonHelper(json, ejson);
    e.test('animations');
    e.test('');
  });
}
