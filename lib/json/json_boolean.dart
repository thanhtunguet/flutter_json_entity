part of 'json.dart';

class JsonBoolean extends JsonField<bool> {
  JsonBoolean(super.fieldName);

  @override
  bool get value {
    assert(rawValue != null);
    return rawValue ?? false;
  }

  @override
  bool? toJSON() {
    return rawValue;
  }
}
