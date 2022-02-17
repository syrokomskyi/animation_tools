import 'dart:convert' as convert;

const _encoder = convert.JsonEncoder.withIndent('  ');

String jsonEncoder(dynamic o) => _encoder.convert(o);

extension ObjectJsonExtension on Object {
  String get sjson => jsonEncoder(this);
}

extension StringJsonExtension on String {
  List<dynamic> get jsonList => convert.json.decode(this) as List<dynamic>;

  Map<String, dynamic> get jsonMap =>
      convert.json.decode(this) as Map<String, dynamic>;
}
