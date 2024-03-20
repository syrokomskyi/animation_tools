import 'dart:io' show File;

import 'package:json_dart/json_dart.dart';

import '../extensions/num_extension.dart';

/// Class for work with Spine skeleton.
class SpineSkeletonJson {
  /// Build with [file].
  SpineSkeletonJson(this.file) : assert(file.existsSync(), file.toString());

  /// Build with [path].
  factory SpineSkeletonJson.path(String path) => SpineSkeletonJson(File(path));

  /// Fields for scale.
  static const needToScaleRootFields = <String>[
    'skeleton',
  ];

  /// Fields for scale.
  static const needToScaleInnerFields = <String>[
    'x',
    'y',
    'width',
    'height',
  ];

  /// Working file for skeleton.
  final File file;

  /// [file] as [String].
  String get raw => file.readAsStringSync();

  /// [file] to [Map].
  JsonMap get json => raw.jsonMap;

  /// Leaves animation contains [names].
  JsonMap leaveAnimations(List<String> names) {
    final newJson = json;
    final animations = newJson['animations'] as JsonMap;
    final keptAnimations = <String, dynamic>{};
    for (final kv in animations.entries) {
      if (names.contains(kv.key)) {
        keptAnimations[kv.key] = kv.value;
      }
    }
    newJson['animations'] = keptAnimations;

    return newJson;
  }

  /// Move animation from [namesFrom] to [nameTo].
  JsonMap moveAnimation(String nameFrom, String nameTo) {
    final newJson = json;
    final animations = newJson['animations'] as JsonMap;
    animations[nameTo] = animations[nameFrom];
    animations.remove(nameFrom);

    return newJson;
  }

  /// Remove animation with [name].
  JsonMap removeAnimation(String name) {
    final newJson = json;
    final animations = newJson['animations'] as JsonMap;
    animations.remove(name);

    return newJson;
  }

  /// Scales animation.
  JsonMap scale(num s) => json.map(
        (String name, dynamic value) => MapEntry<String, dynamic>(
          name,
          needToScaleRootFields.contains(name)
              ? _scale(value as JsonMap, s)
              : value,
        ),
      );

  /// Save [newJson] to [file].
  void save(JsonMap newJson) =>
      file.writeAsStringSync(newJson.sjson, flush: true);

  JsonMap _scale(JsonMap json, num s) {
    return json.map((String name, dynamic value) {
      if (value is Map) {
        final v = _scale(value as JsonMap, s);
        return MapEntry<String, dynamic>(name, v);
      }

      if (value is List) {
        final v = value
            .map<dynamic>((dynamic e) => e is Map ? _scale(e as JsonMap, s) : e)
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
