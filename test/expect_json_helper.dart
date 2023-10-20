import 'package:animation_tools/extensions/json_extension.dart';
import 'package:test/test.dart';

class ExpectJsonHelper {
  const ExpectJsonHelper(dynamic o, dynamic eo)
      : o = o as Map<String, dynamic>,
        eo = eo as Map<String, dynamic>;

  final Map<String, dynamic> o;
  final Map<String, dynamic> eo;

  void test(String name) {
    final dynamic r = name.isEmpty ? o : o[name];
    final dynamic er = name.isEmpty ? eo : eo[name];
    expect(r.runtimeType, er.runtimeType);
    if (r is Map && er is Map) {
      expect(r.length, er.length);
    }
    expect(
      r,
      er,
      reason: 'original\n${jsonEncoder(r)}'
          '\nexpected\n${jsonEncoder(er)}',
    );
  }
}
