part of 'json.dart';

class JsonString extends JsonField {
  JsonString(super.fieldName);

  @override
  String? toJSON() {
    return rawValue;
  }

  @override
  get value => rawValue ?? nullString;
}
