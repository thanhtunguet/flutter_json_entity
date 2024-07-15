part of 'json.dart';

class JsonList<T extends JsonModel> extends JsonField<List<T>> {
  final InstanceConstructor<T> _type;

  JsonList(super.fieldName, InstanceConstructor<T> type) : _type = type {
    rawValue = [];
  }

  @override
  List<T> get value => rawValue ?? [];

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
  List<Map<String, dynamic>>? toJSON() {
    return rawValue?.map((element) => element.toJSON()).toList();
  }

  operator [](int index) {
    if (rawValue == null) {
      return null;
    }
    if (index < 0 || index >= rawValue!.length) {
      throw Exception('Index $index is out of range');
    }
    return rawValue![index];
  }

  operator []=(int index, value) {
    assert(rawValue != null);
    if (rawValue == null) {
      throw Exception('Index $index is out of range');
    }
    if (index < 0 || index >= rawValue!.length) {
      throw Exception('Index $index is out of range');
    }
    rawValue![index] = value;
  }
}
