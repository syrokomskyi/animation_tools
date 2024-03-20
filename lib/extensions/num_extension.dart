import 'dart:math';

/// ! Copied from `dart_helpers`.
extension DoubleExtension on double {
  /// A fixed digits after point for [double].
  static const zeroValue = 0.01;

  /// Use [zeroValue].
  bool get isNearZero => isNear(0.0);

  /// Use [zeroValue].
  bool get isNearOne => isNear(1.0);

  /// Use [zeroValue].
  bool isNear(double v) => (this - v).abs() < zeroValue;

  /// Rounds to 0 digits.
  double get n0 => round().roundToDouble();

  /// Rounds to 1 digit.
  double get n1 => np(1);

  /// Rounds to 2 digits.
  double get n2 => np(2);

  /// Rounds to 3 digits.
  double get n3 => np(3);

  /// Rounds to 4 digits.
  double get n4 => np(4);

  /// Rounds to [digits] digits.
  double np(int digits) {
    final p = pow(10, digits);
    return (this * p).roundToDouble() / p;
  }

  /// Fixed to 0 digits.
  String get s0 => toStringAsFixed(0);

  /// Fixed to 1 digit.
  String get s1 => toStringAsFixed(1);

  /// Fixed to 2 digits.
  String get s2 => toStringAsFixed(2);

  /// Fixed to 3 digits.
  String get s3 => toStringAsFixed(3);

  /// Fixed to 4 digits.
  String get s4 => toStringAsFixed(4);
}
