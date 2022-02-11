import 'dart:io' show File;

import '../extensions/json_extension.dart';
import '../extensions/num_extension.dart';

class SpineSkeletonJson {
  static const needToScaleFields = <String>[
    'x',
    'y',
    'width',
    'height',
    'length',
  ];

  final File file;

  SpineSkeletonJson(this.file) : assert(file.existsSync());

  void scaleAndSave(double s) {
    final raw = file.readAsStringSync();
    final json = raw.jsonMap;
    final newJson = _scale(json, s);
    file.writeAsStringSync(newJson.sjson, flush: true);
  }

  Map<String, dynamic> _scale(Map<String, dynamic> json, double s) {
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

      if (value is num && needToScaleFields.contains(name)) {
        final v = value * s;
        //print('`$name` scaled from $value to $v');
        return MapEntry<String, dynamic>(name, value is int ? v.round() : v.n4);
      }

      // don't scale other values
      return MapEntry<String, dynamic>(name, value);
    });
  }
}
