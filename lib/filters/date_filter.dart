part of "filters.dart";

/// This class defines filter operations for DateTime type
///
/// Because DateTime can be treated as number (with same operations),
/// we use NumberFilter as interface of this class
class DateFilter extends AbstractNumberFilter<DateTime> {
  /// Initialize new DateFilter instance
  DateFilter(super.fieldName);

  /// Convert this DateFilter to JSON
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (equal != null) {
      json[FilterField.equal] = equal!.toIso8601StringWithOffset();
    }
    if (notEqual != null) {
      json[FilterField.notEqual] = notEqual!.toIso8601StringWithOffset();
    }
    if (greaterEqual != null) {
      json[FilterField.greaterEqual] =
          greaterEqual!.toIso8601StringWithOffset();
    }
    if (greater != null) {
      json[FilterField.greater] = greater!.toIso8601StringWithOffset();
    }
    if (lessEqual != null) {
      json[FilterField.lessEqual] = lessEqual!.toIso8601StringWithOffset();
    }
    if (less != null) {
      json[FilterField.less] = less!.toIso8601StringWithOffset();
    }
    return json;
  }

  /// Deserialize data from JSON
  @override
  void fromJson(dynamic json) {
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
