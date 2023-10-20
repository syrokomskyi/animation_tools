import 'dart:io' show File;

import '../extensions/json_extension.dart';
import '../extensions/num_extension.dart';

class SpineSkeletonJson {
  SpineSkeletonJson(this.file) : assert(file.existsSync(), file.toString());

  factory SpineSkeletonJson.path(String path) => SpineSkeletonJson(File(path));

  static const needToScaleRootFields = <String>[
    'skeleton',
  ];
  static const needToScaleInnerFields = <String>[
    'x',
    'y',
    'width',
    'height',
  ];

  final File file;

  String get raw => file.readAsStringSync();

  Map<String, dynamic> get json => raw.jsonMap;

  Map<String, dynamic> leaveAnimations(List<String> names) {
    final newJson = json;
    final animations = newJson['animations'] as Map<String, dynamic>;
    final keptAnimations = <String, dynamic>{};
    for (final kv in animations.entries) {
      if (names.contains(kv.key)) {
        keptAnimations[kv.key] = kv.value;
      }
    }
    newJson['animations'] = keptAnimations;

    return newJson;
  }

  Map<String, dynamic> moveAnimation(String nameFrom, String nameTo) {
    final newJson = json;
    final animations = newJson['animations'] as Map<String, dynamic>;
    animations[nameTo] = animations[nameFrom];
    animations.remove(nameFrom);

    return newJson;
  }

  Map<String, dynamic> removeAnimation(String name) {
    final newJson = json;
    final animations = newJson['animations'] as Map<String, dynamic>;
    animations.remove(name);

    return newJson;
  }

  Map<String, dynamic> scale(num s) => json.map<String, dynamic>(
        (String name, dynamic value) => MapEntry<String, dynamic>(
          name,
          needToScaleRootFields.contains(name)
              ? _scale(value as Map<String, dynamic>, s)
              : value,
        ),
      );

  void save(Map<String, dynamic> newJson) =>
      file.writeAsStringSync(newJson.sjson, flush: true);

  Map<String, dynamic> _scale(Map<String, dynamic> json, num s) {
    return json.map<String, dynamic>((String name, dynamic value) {
      if (value is Map) {
        final v = _scale(value as Map<String, dynamic>, s);
        return MapEntry<String, dynamic>(name, v);
      }

      if (value is List) {
        final v = value
            .map<dynamic>((dynamic e) =>
                e is Map ? _scale(e as Map<String, dynamic>, s) : e)
            .toList();
        return MapEntry<String, dynamic>(name, v);
      }

      if (value is num && needToScaleInnerFields.contains(name)) {
        final v = value * s;
        //print('`$name` scaled from $value to $v');
        return MapEntry<String, dynamic>(
          name,
          value is int ? v.round() : (v as double).n4,
        );
      }

      // don't scale other values
      return MapEntry<String, dynamic>(name, value);
    });
  }
}
