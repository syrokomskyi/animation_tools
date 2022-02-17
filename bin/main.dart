import 'package:animation_tools/spine/spine_animation_tools.dart';
import 'package:args/args.dart';

void main(List<String> args) async {
  final parser = ArgParser();
  parser.addOption(
    'source',
    help: 'Path to animation folder.',
    mandatory: true,
  );

  parser.addOption('copy', help: 'Copy or/and rename animation.');
  parser.addOption('scale', help: 'Scale animation.');

  parser.addOption('move_animation', help: 'Move animation.');
  parser.addOption('remove_animation', help: 'Remove animation.');
  parser.addOption('leave_animations', help: 'Leave only animations.');

  final results = parser.parse(args);

  // source
  var sourcePath = '';
  if (results.wasParsed('source')) {
    sourcePath = results['source'] as String;
  }
  if (sourcePath.isEmpty) {
    throw ArgumentError.value(sourcePath, 'source', 'Should be defined.');
  }

  final tools = SpineAnimationTools(sourcePath);
  await tools.check();

  // copy
  if (results.wasParsed('copy')) {
    var copyPath = results['copy'] as String;
    if (copyPath.isEmpty) {
      copyPath = sourcePath;
    }
    await tools.copy(copyPath);
  }

  // scale
  if (results.wasParsed('scale')) {
    final s = results['scale'] as String;
    final scale = num.parse(s);
    await tools.scale(scale);
  }

  // move_animation
  if (results.wasParsed('move_animation')) {
    final raw = results['move_animation'] as String;
    final list = raw.split(' ');
    if (list.length != 2) {
      throw ArgumentError.value(
        raw,
        'move_animation',
        'Should be space separated names like `from_name to_name`.',
      );
    }
    await tools.moveAnimation(list.first, list.last);
  }

  // remove_animation
  if (results.wasParsed('remove_animation')) {
    final raw = results['remove_animation'] as String;
    final list = raw.split(' ');
    if (list.length != 1) {
      throw ArgumentError.value(
        raw,
        'remove_animation',
        'Should be one name without spaces.',
      );
    }
    await tools.removeAnimation(list.first);
  }

  // leave_animations
  if (results.wasParsed('leave_animations')) {
    final raw = results['leave_animations'] as String;
    final list = raw.split(' ');
    if (list.isEmpty) {
      throw ArgumentError.value(
        raw,
        'leave_animations',
        'Should be space separated names.'
            ' For example: `idle walk run shoot`.',
      );
    }
    await tools.leaveAnimations(list);
  }
}
