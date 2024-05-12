import 'dart:convert';

class Doc {
  late final String id;
  late final String doc;

  Doc(this.id, this.doc);

  Map<String, dynamic> data() {
    return jsonDecode(doc == '' ? '{}' : doc);
  }
}
