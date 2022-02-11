import 'dart:io' show File;

import '../extensions/num_extension.dart';

class SpineTextureAtlas {
  final File file;

  SpineTextureAtlas(this.file) : assert(file.existsSync());

  void scale(double s) {
    final raw = file.readAsStringSync();
    final lines = raw.split('\n');
    for (final line in lines) {
      if (line.isEmpty) {
        continue;
      }

      // \TODO

    }

    file.writeAsStringSync(raw, flush: true);
  }
}

abstract class SizedElement<T extends num> {
  String raw;

  List<num> get numbers => RegExp(r'\d+').allMatches(raw).map((match) {
        final v = num.parse(match[0] ?? '-1');
        return v is double ? v.n2 : v;
      }).toList();

  num get x => v(0);

  set x(num value) =>
      raw = raw.replaceFirstMapped(RegExp(r'\d+,'), (match) => '$value,');

  num get y => v(1);

  set y(num value) =>
      raw = raw.replaceFirstMapped(RegExp(r', \d+'), (match) => ', $value');

  num v(int i) {
    final number = numbers[i];
    if (number is double) {
      return number.n2;
    }

    return number;
  }

  SizedElement(this.raw) : assert(raw.isNotEmpty);

  void scale(double s);

  @override
  String toString() => raw;
}

// xy: 2, 690
class XY extends SizedElement<int> {
  XY(String raw) : super(raw);

  @override
  void scale(double s) {
    x = (x * s).toInt();
    y = (y * s).toInt();
  }
}

// size: 122, 143

// orig: 122, 143

// offset: 0, 0
