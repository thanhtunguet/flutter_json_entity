part of 'filters.dart';

/// Base class for filter classes
abstract interface class FilterField implements JsonSerializable {
  static const String less = "less";

  static const String lessEqual = "lessEqual";

  static const String greater = "greater";

  static const String greaterEqual = "greaterEqual";

  static const String equal = "equal";

  static const String notEqual = "notEqual";

  static const String contain = "contain";

  static const String notContain = "notContain";

  static const String startWith = "startWith";

  static const String notStartWith = "notStartWith";

  static const String endWith = "endWith";

  static const String notEndWith = "notEndWith";

  static const String inList = "in";

  static const String notInList = "notIn";

  static const String search = "search";

  static const String viewCode = "viewCode";

  final String name;

  FilterField(this.name);

  /// Convert this filter directly to JSON string
  @override
  String toString() {
    return jsonEncode(toJSON());
  }
}
