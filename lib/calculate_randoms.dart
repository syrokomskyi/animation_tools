import 'dart:math';

List<int> calculateRandoms(int seed, [int maxValue = 1000000, int n = 10]) {
  final rand = Random(seed);
  return List.generate(n, (index) => rand.nextInt(maxValue));
}
