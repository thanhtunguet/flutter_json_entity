part of "filters.dart";

/// Base class for filter classes.
///
/// This abstract class defines common filter operations and provides
/// methods for JSON serialization. It includes various constants representing
/// different types of filter operations.
abstract interface class FilterField implements JsonSerializable {
  /// Represents a "less than" filter operation.
  static const String less = "less";

  /// Represents a "less than or equal to" filter operation.
  static const String lessEqual = "lessEqual";

  /// Represents a "greater than" filter operation.
  static const String greater = "greater";

  /// Represents a "greater than or equal to" filter operation.
  static const String greaterEqual = "greaterEqual";

  /// Represents an "equal to" filter operation.
  static const String equal = "equal";

  /// Represents a "not equal to" filter operation.
  static const String notEqual = "notEqual";

  /// Represents a "contains" filter operation.
  static const String contain = "contain";

  /// Represents a "does not contain" filter operation.
  static const String notContain = "notContain";

  /// Represents a "starts with" filter operation.
  static const String startWith = "startWith";

  /// Represents a "does not start with" filter operation.
  static const String notStartWith = "notStartWith";

  /// Represents an "ends with" filter operation.
  static const String endWith = "endWith";

  /// Represents a "does not end with" filter operation.
  static const String notEndWith = "notEndWith";

  /// Represents an "in list" filter operation.
  static const String inList = "in";

  /// Represents a "not in list" filter operation.
  static const String notInList = "notIn";

  /// Represents a "search" filter operation.
  static const String search = "search";

  /// Represents a "view code" filter operation.
  static const String viewCode = "viewCode";

  /// The name of the filter field.
  final String name;

  /// Constructs an instance of [FilterField].
  ///
  /// **Parameters:**
  /// - `name`: The name of the filter field.
  FilterField(this.name);

  /// Converts this filter directly to a JSON string.
  @override
  String toString() {
    return jsonEncode(toJSON());
  }
}
