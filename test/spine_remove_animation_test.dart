import 'package:animation_tools/extensions/json_extension.dart';
import 'package:animation_tools/spine/spine_animation_tools.dart';
import 'package:animation_tools/spine/spine_skeleton_json.dart';
import 'package:test/test.dart';

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

    final e = ExpectTest(json, ejson);
    e.test('animations');
    e.test('');
  });
}

class ExpectTest {
  final Map<String, dynamic> o;
  final Map<String, dynamic> eo;

  const ExpectTest(dynamic o, dynamic eo)
      : o = o as Map<String, dynamic>,
        eo = eo as Map<String, dynamic>;

  void test(String name) {
    final dynamic r = name.isEmpty ? o : o[name];
    final dynamic er = name.isEmpty ? eo : eo[name];
    expect(r.runtimeType, er.runtimeType);
    if (r is Map && er is Map) {
      expect(r.length, er.length);
    }
    expect(
      r,
      er,
      reason: 'original\n${jsonEncoder(r)}'
          '\nexpected\n${jsonEncoder(er)}',
    );
  }
}
