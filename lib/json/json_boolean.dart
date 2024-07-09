part of 'json.dart';

class JsonBoolean extends JsonField<bool> {
  JsonBoolean(super.fieldName);

  @override
  bool? toJSON() {
    return rawValue;
  }
}
