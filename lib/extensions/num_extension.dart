import 'dart:math';

extension DoubleExtension on double {
  static const zeroValue = 0.01;

  bool get isNearZero => isNear(0.0);

  bool get isNearOne => isNear(1.0);

  bool isNear(double v) => (this - v).abs() < zeroValue;

  double get n0 => round().roundToDouble();

  double get n1 => np(1);

  double get n2 => np(2);

  double get n3 => np(3);

  double get n4 => np(4);

  double np(int digits) {
    final p = pow(10, digits);
    return (this * p).roundToDouble() / p;
  }

  String get s0 => toStringAsFixed(0);

  String get s1 => toStringAsFixed(1);

  String get s2 => toStringAsFixed(2);

  String get s3 => toStringAsFixed(3);

  String get s4 => toStringAsFixed(4);
}
