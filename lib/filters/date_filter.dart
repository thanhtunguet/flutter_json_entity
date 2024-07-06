part of 'filters.dart';

/// This class defines filter operations for DateTime type
///
/// Because DateTime can be treated as number (with same operations),
/// we use NumberFilter as interface of this class
class DateFilter extends AbstractNumberFilter<DateTime> {
  /// Initialize new DateFilter instance
  DateFilter(super.fieldName);

  /// Convert this DateFilter to JSON
  @override
  Map<String, dynamic> toJSON() {
    Map<String, dynamic> json = {};
    if (equal != null) {
      json[FilterField.equal] = equal!.toIso8601String();
    }
    if (notEqual != null) {
      json[FilterField.notEqual] = notEqual!.toIso8601String();
    }
    if (greaterEqual != null) {
      json[FilterField.greaterEqual] = greaterEqual!.toIso8601String();
    }
    if (greater != null) {
      json[FilterField.greater] = greater!.toIso8601String();
    }
    if (lessEqual != null) {
      json[FilterField.lessEqual] = lessEqual!.toIso8601String();
    }
    if (less != null) {
      json[FilterField.less] = less!.toIso8601String();
    }
    return json;
  }

  /// Deserialize data from JSON
  @override
  void fromJSON(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return;
    }

    if (json.containsKey(FilterField.greaterEqual)) {
      greaterEqual = DateTime.parse(json[FilterField.greaterEqual]);
    }
    if (json.containsKey(FilterField.lessEqual)) {
      lessEqual = DateTime.parse(json[FilterField.lessEqual]);
    }
    if (json.containsKey(FilterField.greater)) {
      greater = DateTime.parse(json[FilterField.greater]);
    }
    if (json.containsKey(FilterField.less)) {
      less = DateTime.parse(json[FilterField.less]);
    }
    if (json.containsKey(FilterField.equal)) {
      equal = DateTime.parse(json[FilterField.equal]);
    }
    if (json.containsKey(FilterField.notEqual)) {
      notEqual = DateTime.parse(json[FilterField.notEqual]);
    }
  }
}
