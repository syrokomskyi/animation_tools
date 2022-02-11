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

  List<num> get numbers => RegExp(r'\d+')
      .allMatches(raw)
      .map((match) => num.parse(match[0] ?? '-1'))
      .toList();

  num get x => v(0);

  set x(num value) =>
      raw = raw.replaceFirstMapped(RegExp(r'\d+,'), (match) => '$value,');

  num get y => v(1);

  set y(num value) =>
      raw = raw.replaceFirstMapped(RegExp(r', \d+'), (match) => ', $value');

  num v(int i) => numbers[i];

  SizedElement(this.raw) : assert(raw.isNotEmpty);

  void scale(double s) {
    final a = x * s;
    x = T is double ? a.n2 : a.n0.toInt();
    final b = y * s;
    y = T is double ? b.n2 : b.n0.toInt();
  }

  @override
  String toString() => raw;
}

// xy: 2, 690
class XY extends SizedElement<int> {
  XY(String raw) : super(raw);
}

// size: 122, 143
class Size extends SizedElement<int> {
  Size(String raw) : super(raw);
}

// orig: 122, 143
class Orig extends SizedElement<int> {
  Orig(String raw) : super(raw);
}

// offset: 2, 3
class Offset extends SizedElement<int> {
  Offset(String raw) : super(raw);
}
