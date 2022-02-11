import 'dart:convert' as convert;

const _encoder = convert.JsonEncoder.withIndent('  ');

extension ObjectJsonExtension on Object {
  String get sjson => _encoder.convert(this);
}

extension StringJsonExtension on String {
  List<dynamic> get jsonList => convert.json.decode(this) as List<dynamic>;

  Map<String, dynamic> get jsonMap =>
      convert.json.decode(this) as Map<String, dynamic>;
}
