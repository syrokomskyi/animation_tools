import 'package:animation_tools/spine/spine_animation_tools.dart';

void main() async {
  const sourcePath = './test/data/owl';
  const copyPath = './_output/owl_75';
  final tools = SpineAnimationTools(sourcePath);
  await tools.copy(copyPath);
  await tools.scale(0.75);
}
