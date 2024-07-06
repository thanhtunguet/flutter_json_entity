part of 'filters.dart';

/// This class defines filter operations for all Dart's number types
/// (including int, double or generic num)
///
/// This class also be used as interface of DateFilter
class AbstractNumberFilter<T> extends FilterField {
  /// Query all records that has its field's value is greater than or equal to this property's value
  T? greaterEqual;

  /// Query all records that has its field's value is less than or equal to this property's value
  T? lessEqual;

  /// Query all records that has its field's value is greater than this property's value
  T? greater;

  /// Query all records that has its field's value is less than this property's value
  T? less;

  /// Query all records that has its field's value is equal to this property's value
  T? equal;

  /// Query all records that has its field's value is not equal to this property's value
  T? notEqual;

  /// Initialize new NumberFilter instance
  AbstractNumberFilter(super.fieldName);

  /// Deserialize a JSON object to map values to this NumberFilter
  @override
  void fromJSON(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return;
    }

    if (json.containsKey(FilterField.greaterEqual)) {
      greaterEqual = json[FilterField.greaterEqual];
    }
    if (json.containsKey(FilterField.lessEqual)) {
      lessEqual = json[FilterField.lessEqual];
    }
    if (json.containsKey(FilterField.greater)) {
      greater = json[FilterField.greater];
    }
    if (json.containsKey(FilterField.less)) {
      less = json[FilterField.less];
    }
    if (json.containsKey(FilterField.equal)) {
      equal = json[FilterField.equal];
    }
    if (json.containsKey(FilterField.notEqual)) {
      notEqual = json[FilterField.notEqual];
    }
  }

  /// Convert this NumberFilter to JSON
  @override
  Map<String, dynamic> toJSON() {
    Map<String, T?> json = {};
    if (equal != null) {
      json[FilterField.equal] = equal;
    }
    if (notEqual != null) {
      json[FilterField.notEqual] = notEqual;
    }
    if (lessEqual != null) {
      json[FilterField.lessEqual] = lessEqual;
    }
    if (less != null) {
      json[FilterField.less] = less;
    }
    if (greaterEqual != null) {
      json[FilterField.greaterEqual] = greaterEqual;
    }
    if (greater != null) {
      json[FilterField.greater] = greater;
    }
    return json;
  }
}
