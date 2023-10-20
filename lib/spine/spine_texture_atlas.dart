import 'dart:io' show File;

import '../extensions/num_extension.dart';

class SpineTextureAtlas {
  SpineTextureAtlas(this.file) : assert(file.existsSync());

  final File file;

  bool hasReferenceToTexture(String name) {
    assert(name.isNotEmpty);

    final raw = file.readAsStringSync();
    final lines = raw.split('\n');
    for (final line in lines) {
      if (line.contains(name)) {
        return true;
      }
    }

    return false;
  }

  void scaleAndSave(num s) {
    final r = <String>[];

    final raw = file.readAsStringSync();
    final lines = raw.split('\n');
    for (final line in lines) {
      r.add(line);

      if (line.isEmpty) {
        continue;
      }

      final sized = SizedElementFactory.createFromString(line);
      if (sized == null) {
        continue;
      }

      sized.scale(s);
      r.last = sized.toString();
    }

    final newRaw = r.join('\n');
    file.writeAsStringSync(newRaw, flush: true);
  }
}

// ignore: avoid_classes_with_only_static_members
class SizedElementFactory {
  static SizedElement? createFromString(String s) {
    if (s.contains('xy:')) {
      return XY(s);
    }

    if (s.contains('size:')) {
      return Size(s);
    }

    if (s.contains('orig:')) {
      return Orig(s);
    }

    if (s.contains('offset:')) {
      return Offset(s);
    }

    return null;
  }
}

/// \warning Today recognize only with integer numbers.
/// \todo Recognize double numbers.
abstract class SizedElement<T extends num> {
  SizedElement(this.raw) : assert(raw.isNotEmpty);
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

  void scale(num s) {
    final a = x * s.toDouble();
    x = T is double ? a.n4 : a.round();
    final b = y * s.toDouble();
    y = T is double ? b.n4 : b.round();
  }

  @override
  String toString() => raw;
}

// xy: 2, 690
class XY extends SizedElement<int> {
  XY(super.raw);
}

// size: 122, 143
class Size extends SizedElement<int> {
  Size(super.raw);
}

// orig: 122, 143
class Orig extends SizedElement<int> {
  Orig(super.raw);
}

// offset: 2, 3
class Offset extends SizedElement<int> {
  Offset(super.raw);
}
