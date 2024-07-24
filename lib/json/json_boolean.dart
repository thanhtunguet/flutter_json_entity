part of 'json.dart';

class JsonBoolean extends JsonField<bool> {
  JsonBoolean(super.fieldName);

  @override
  bool get value {
    return rawValue ?? false;
  }

  @override
  bool? toJSON() {
    return rawValue;
  }
}
