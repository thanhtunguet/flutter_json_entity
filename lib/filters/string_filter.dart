part of 'filters.dart';

/// This class defines filter operations for String type
class StringFilter extends FilterField {
  /// Query all records that has its field's value equals to this property's value
  String? equal;

  /// Query all records that has its field's value different from this property's value
  String? notEqual;

  /// Query all records that has its field's value starts with this property's value
  String? startWith;

  /// Query all records that has its field's value does not start with this property's value
  String? notStartWith;

  /// Query all records that has its field's value ends with this property's value
  String? endWith;

  /// Query all records that has its field's value does not end with this property's value
  String? notEndWith;

  /// Query all records that has its field's value contains this property's value
  String? contain;

  /// Query all records that has its field's value does not contain this property's value
  String? notContain;

  /// Initialize new StringFilter instance
  StringFilter(super.fieldName);

  /// Convert this filter from JSON
  @override
  void fromJSON(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return;
    }
    if (json.containsKey(FilterField.equal)) {
      equal = json[FilterField.equal];
    }
    if (json.containsKey(FilterField.notEqual)) {
      notEqual = json[FilterField.notEqual];
    }
    if (json.containsKey(FilterField.startWith)) {
      startWith = json[FilterField.startWith];
    }
    if (json.containsKey(FilterField.notStartWith)) {
      notStartWith = json[FilterField.notStartWith];
    }
    if (json.containsKey(FilterField.endWith)) {
      endWith = json[FilterField.endWith];
    }
    if (json.containsKey(FilterField.contain)) {
      contain = json[FilterField.contain];
    }
    if (json.containsKey(FilterField.notContain)) {
      notEqual = json[FilterField.notContain];
    }
  }

  /// Convert this filter to JSON
  @override
  Map<String, dynamic> toJSON() {
    Map<String, String?> json = {};
    if (equal != null) {
      json[FilterField.equal] = equal;
    }
    if (notEqual != null) {
      json[FilterField.notEqual] = notEqual;
    }
    if (startWith != null) {
      json[FilterField.startWith] = startWith;
    }
    if (notStartWith != null) {
      json[FilterField.notStartWith] = notStartWith;
    }
    if (endWith != null) {
      json[FilterField.endWith] = endWith;
    }
    if (notEndWith != null) {
      json[FilterField.notEndWith] = notEndWith;
    }
    if (contain != null) {
      json[FilterField.contain] = contain;
    }
    if (notContain != null) {
      json[FilterField.notContain] = notContain;
    }
    return json;
  }
}
