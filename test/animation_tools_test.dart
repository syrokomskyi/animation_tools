import 'package:animation_tools/animation_tools.dart';
import 'package:test/test.dart';

void main() {
  test('calculateRandoms', () {
    const seed = 12345;
    expect(calculateRandoms(seed, 50, 3), <int>[31, 48, 30]);
  });
}
