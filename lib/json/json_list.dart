part of 'json.dart';

class JsonList<T extends JsonModel> extends JsonField<List<T>> {
  final InstanceConstructor<T> _type;

  @override
  List<T>? _value;

  JsonList(super.fieldName, InstanceConstructor<T> type)
      : _type = type,
        _value = [];

  @override
  set value(dynamic value) {
    if (value is List<T>) {
      _value = value;
      return;
    }
    if (value is List) {
      _value = value.map((element) {
        final model = _type();
        model.fromJSON(element);
        return model;
      }).toList();
    }
  }

  @override
  toJSON() {
    return _value?.map((element) => element.toJSON()).toList();
  }
}
