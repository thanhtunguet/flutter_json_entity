part of 'json.dart';

mixin JsonSerializable {
  void fromJSON(dynamic json);

  dynamic toJSON();
}
