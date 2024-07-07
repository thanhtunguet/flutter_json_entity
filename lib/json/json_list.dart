part of 'json.dart';

class JsonList<T extends JsonModel> extends JsonField<List<T>> {
  final InstanceConstructor<T> _type;

  JsonList(super.fieldName, InstanceConstructor<T> type) : _type = type {
    rawValue = [];
  }

  @override
  set value(dynamic value) {
    if (value is List<T>) {
      rawValue = value;
      return;
    }
    if (value is List) {
      rawValue = value.map((element) {
        final model = _type();
        model.fromJSON(element);
        return model;
      }).toList();
    }
  }

  @override
  toJSON() {
    return rawValue?.map((element) => element.toJSON()).toList();
  }
}
